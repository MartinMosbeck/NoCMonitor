#!/bin/python3
from PyQt5 import QtCore, QtGui, QtWidgets
from configNoC import Ui_configNoC
from configPE import Ui_configPE
from mainWindow import Ui_mainWindow

import sys
import math
import string
from enum import Enum
import functools

from BitVector import *

from jinja2 import Environment, FileSystemLoader

class Traffic_Patterns(Enum):
    random = 0
    bit_complement = 1
    bit_reverse = 2
    bit_rotation = 3
    transpose = 4
    shuffle = 5
    manual = 6

class NoC_Configurator:
    def init(self):
        self.app = QtWidgets.QApplication(sys.argv)
        self.mainWindow = QtWidgets.QMainWindow()
        self.mainWindow_ui = Ui_mainWindow()
        self.mainWindow_ui.setupUi(self.mainWindow)
        self.mainWindow.show()
        self.mainWindow_ui.actionCreate_new_Configuration.triggered.connect(self.new_config)
        self.mainWindow_ui.actionConfigure_PEs.triggered.connect(self.configure_PEs)
        self.mainWindow_ui.actionCreate_Files.triggered.connect(self.create_Files)
        self.define_mesh_variables()

    def execute(self):
        sys.exit(self.app.exec_())

    def define_mesh_variables(self):
        self.mesh_configured = False
        self.mesh_height = 1
        self.mesh_width = 1
        self.connect_directory = ""
        self.flit_data_width = 1
        self.flit_buffer_depth = 1
        self.num_vc= 2
        self.default_traffic_pattern = Traffic_Patterns.random
        self.default_packet_injection_rate = 0.1
        self.default_flits_per_packet = 1


    def new_config(self):
        self.configNoC = QtWidgets.QDialog()
        self.configNoC_ui = Ui_configNoC()
        self.configNoC_ui.setupUi(self.configNoC)
        self.configNoC_ui.default_traffic_pattern.setCurrentIndex(2)
        self.configNoC.show()
        self.configNoC.accepted.connect(functools.partial(self.new_config_accepted,self.configNoC_ui))

    def new_config_accepted(self,configNoC_ui):
        self.mesh_configured = True
        self.mesh_height = configNoC_ui.mesh_height.value()
        self.mesh_width = configNoC_ui.mesh_width.value()
        self.connect_directory = configNoC_ui.connect_directory.text()
        self.flit_data_width = configNoC_ui.flit_data_width.value()
        self.flit_buffer_depth = configNoC_ui.flit_buffer_depth.value()
        self.num_vc= configNoC_ui.virtual_channels.value()
        self.default_traffic_pattern = Traffic_Patterns(configNoC_ui.default_traffic_pattern.currentIndex())
        self.default_packet_injection_rate = configNoC_ui.default_packet_injection_rate.value()
        self.default_flits_per_packet = configNoC_ui.default_flits_per_packet.value()

    def configure_PEs(self):
        if(self.mesh_configured == False):
            #TODO: Popup Messagebox
            return
        self.createButtonMesh()
        self.setPEDefaults()

    def createButtonMesh(self):
        self.PE_button=[]
        for i in range(0,self.mesh_width*self.mesh_height):
            self.PE_button.append(QtWidgets.QPushButton(self.mainWindow_ui.gridLayoutWidget))
            self.PE_button[i].setText("PE_"+str(i))
            self.PE_button[i].clicked.connect(functools.partial(self.configurePE,i))

        num = 0

        for row in range(self.mesh_height-1,-1,-1):
            for column in range(0,self.mesh_width):
                self.mainWindow_ui.gridLayout.addWidget(self.PE_button[num], row, column)
                num = num+1

    def setPEDefaults(self):
        #TODO: handle random and manulal
        self.PE_traffic_pattern = []
        self.PE_dest = []
        self.PE_packet_injection_rate = []
        self.PE_flits_per_packet = []
        self.PE_enabled = []

        for i in range (0,self.mesh_width*self.mesh_height):
            self.PE_traffic_pattern.append(self.default_traffic_pattern)
            
            #for manual set to 0 for default 
            if(self.default_traffic_pattern==Traffic_Patterns.manual):
                self.PE_dest.append(0)
            else:
                self.PE_dest.append(self.pattern_to_dest(self.default_traffic_pattern,i))
            self.PE_packet_injection_rate.append(self.default_packet_injection_rate)
            self.PE_flits_per_packet.append(self.default_flits_per_packet)  
            self.PE_enabled.append(True)                      


    def configurePE(self,X):
        self.configPE = None
        self.configPE_ui = None

        self.configPE = QtWidgets.QDialog()
        self.configPE_ui = Ui_configPE()
        self.configPE_ui.setupUi(self.configPE)
        self.setValues_PEui(self.configPE_ui,X)
        self.configPE.accepted.connect(functools.partial(self.PE_config_accepted,self.configPE_ui,X))
        self.configPE_ui.traffic_pattern.currentIndexChanged.connect(functools.partial(self.onTrafficPatternChanged,self.configPE_ui,X))
        self.configPE.show()

    def setValues_PEui(self,ui,X):
        #TODO: handle random
        ui.PE_label.setText("PE_{0} Parameters".format(X))
        ui.PE_enabled.setChecked(True);
        ui.traffic_pattern.setCurrentIndex(self.PE_traffic_pattern[X].value)
        #if manual enable the dest field
        if(self.PE_traffic_pattern[X]==Traffic_Patterns.manual):
            ui.implied_destination.setEnabled(True);
  
        ui.implied_destination.setText(str(self.PE_dest[X]))
        ui.packet_injection_rate.setValue(self.PE_packet_injection_rate[X])
        ui.flits_per_packet.setValue(self.PE_flits_per_packet[X])
        ui.PE_enabled.setChecked(self.PE_enabled[X])
    
    def onTrafficPatternChanged (self,ui,X):
        new_traffic_pattern=Traffic_Patterns(ui.traffic_pattern.currentIndex())
        #enable if manual selected
        if(new_traffic_pattern==Traffic_Patterns.manual):
            ui.implied_destination.setEnabled(True)
        else:
            new_dest= self.pattern_to_dest(new_traffic_pattern,X)
            ui.implied_destination.setText(str(new_dest))
            ui.implied_destination.setEnabled(False);

    def PE_config_accepted(self,ui,X):
        self.PE_traffic_pattern[X] = Traffic_Patterns(ui.traffic_pattern.currentIndex())
        self.PE_dest[X] = int(ui.implied_destination.text())
        self.PE_packet_injection_rate[X] = ui.packet_injection_rate.value()
        self.PE_flits_per_packet[X] = ui.flits_per_packet.value()
        self.PE_enabled[X] = ui.PE_enabled.isChecked()

    def pattern_to_dest(self,pattern,X):
        # return -1 is reserved for random
        bit_len = math.ceil(math.log(self.mesh_width*self.mesh_height,2))
        bv = BitVector(intVal=X,size=bit_len)

        if(pattern==Traffic_Patterns.random):
            return -1;
        
        elif(pattern==Traffic_Patterns.bit_complement):
            return int(~bv)

        elif(pattern==Traffic_Patterns.bit_reverse):
            return int(bv.reverse())

        elif(pattern==Traffic_Patterns.bit_rotation):
            return int(bv<<1)

        elif(pattern==Traffic_Patterns.transpose):
           return 1

        elif(pattern==Traffic_Patterns.shuffle):
            t = bv[bit_len-1]
            bv[bit_len-1] = bv[0]
            bv[0] = t
            return int(bv)

        elif(pattern==Traffic_Patterns.manual):
            return self.PE_dest[X]


    def setUpTemplateEnv(self):
        self.template_dir= "../../templates/"
        self.output_dir= self.connect_directory + "/"
        self.jinja2_env=Environment(loader=FileSystemLoader(self.template_dir), lstrip_blocks= True, trim_blocks=True, extensions=['jinja2.ext.do'])
        self.pb= '//--------BEGIN PATCH--------//\n'
        self.pe= '\n//--------END_PATCH--------//\n'

    def create_Files(self):

        self.setUpTemplateEnv()

        #calculate PIR to send_counter_increment
        PE_send_counter_increment = []
        for i in range(0,self.mesh_width*self.mesh_height):
            PE_send_counter_increment.append(math.floor(10.0*self.PE_packet_injection_rate[i]))

        #create individual PE_X.v files
        template = self.jinja2_env.get_template("creating/PE_X.temp")

        for i in range(0,self.mesh_width*self.mesh_height):
            file_out_name= self.output_dir + "PE_{0}.v".format(i)
            data_out = template.render(X=i,DEST=self.PE_dest[i],SEND_COUNTER_INCREMENT=PE_send_counter_increment[i])
            file_out = open(file_out_name,"w")
            file_out.write(data_out)
            file_out.close()
        
        #create connection_elements
        template = self.jinja2_env.get_template("creating/connection_element.temp")
        connection_elements=template.render(ROUTERNUM=self.mesh_width*self.mesh_height)


        #create PE instatiations
        template = self.jinja2_env.get_template("creating/create_PE.temp")
        createPEs = template.render(ROUTERNUM=self.mesh_width*self.mesh_height)

        #create mapping_MkNetwork
        template = self.jinja2_env.get_template("creating/mapping_MkNetwork.temp")
        mappings=template.render(ROUTERNUM=self.mesh_width*self.mesh_height)

        #create enables of PEs

        enables=[]
        for i in range(0,self.mesh_width*self.mesh_height):
            if(self.PE_enabled[i] == True):
                enables.append(1)
            else:
                enables.append(0)

        template = self.jinja2_env.get_template("creating/PE_enable.temp")
        PE_enableds=template.render(ROUTERNUM=self.mesh_width*self.mesh_height,ENABLED=enables)
        

        #create testbench
        template = self.jinja2_env.get_template("creating/testbench.temp")
        data_out = template.render(CONNECTIONS = connection_elements, CREATE_PEs = createPEs, MAPPINGS_mkNetwork = mappings, ENABLES = PE_enableds)

        file_out_name= self.output_dir + "testbench.v"
        file_out = open(file_out_name,"w")
        file_out.write(data_out)
        file_out.close()

        #PATCHING OPERATIONS
        self.patch_MkNetwork()
        self.patch_FIFO()

    def patch_MkNetwork(self):

        file_MkNetwork = open(self.connect_directory+"/mkNetwork.v","r+")
        lines_MkNetwork = file_MkNetwork.readlines()
        lnum_moduleDec = lines_MkNetwork.index('module mkNetwork(CLK,\n')
        lnum_rest = lines_MkNetwork.index('  input  RST_N;\n')

        template = self.jinja2_env.get_template("patching/mkNetwork_01_decForCnt.temp")
        data_out = template.render(ROUTERNUM=self.mesh_height*self.mesh_width)
        ins= self.pb + data_out + self.pe
        lines_MkNetwork.insert(lnum_moduleDec+2,ins)

        template = self.jinja2_env.get_template("patching/mkNetwork_02_assignetc.temp")
        data_out = template.render(ROUTERNUM=self.mesh_height*self.mesh_width,VCNUM=self.num_vc,DATALEN=self.flit_data_width)
        ins= self.pb + data_out + self.pe
        lines_MkNetwork.insert(lnum_rest+2,ins)

        template = self.jinja2_env.get_template("patching/mkNetwork_03_FIFOMapping.temp")

        #do router 0 first because he is special...
        for portnum in range(1,5,1):
            for vcnum in range(0,self.num_vc):
                if(vcnum==0):
                    vcsuffix= ""
                else:
                    vcsuffix= "_"+str(vcnum)
                searchstring= '  mkOutPortFIFO net_routers_router_core{0}_outPortFIFOs{1}{2}(.CLK(CLK),\n'.format("","_"+str(portnum),vcsuffix)
                lnum= lines_MkNetwork.index(searchstring)
                data_out= template.render(ROUTERNUM=0,VCNUM=vcnum,PORTNUM=portnum)
                ins= self.pb + data_out + self.pe
                lines_MkNetwork.insert(lnum+2,ins)
        #do other routers
        for routernum in range(1,self.mesh_width*self.mesh_height):
            for portnum in range(1,5,1):
                for vcnum in range(0,self.num_vc):
                    if(vcnum==0):
                        vcsuffix= ""
                    else:
                        vcsuffix= "_"+str(vcnum)
                    searchstring= '  mkOutPortFIFO net_routers_router_core{0}_outPortFIFOs{1}{2}(.CLK(CLK),\n'.format("_"+str(routernum),"_"+str(portnum),vcsuffix)
                    lnum= lines_MkNetwork.index(searchstring)
                    data_out= template.render(ROUTERNUM=routernum,VCNUM=vcnum,PORTNUM=portnum)
                    ins= self.pb + data_out + self.pe
                    lines_MkNetwork.insert(lnum+2,ins)

        file_MkNetwork.seek(0)
        file_MkNetwork.writelines(lines_MkNetwork)
        file_MkNetwork.truncate()
        file_MkNetwork.close()

    def patch_FIFO(self):

        file_FIFO = open(self.connect_directory+"/mkOutPortFIFO.v","r+")
        lines_FIFO = file_FIFO.readlines();
        lnum_port_dec = lines_FIFO.index('\t\t     RDY_count,\n')
        lnum_rest = lines_FIFO.index('  input  RST_N;\n')
        
        file_in_name = self.template_dir + "patching/mkOutPortFIFO_01_EnqCntDec.temp"
        file_in = open(file_in_name,"r")
        data_in = file_in.read()
        file_in.close()
        ins_port_dec = self.pb + data_in + self.pe
        
        template = self.jinja2_env.get_template("patching/mkOutPortFIFO_02_assignetc.temp")
        data_out = template.render(DATALEN=self.flit_data_width)
        ins_assignetc = self.pb + data_out + self.pe

        lines_FIFO.insert(lnum_port_dec+1,ins_port_dec)
        lines_FIFO.insert(lnum_rest+2,ins_assignetc)

        file_FIFO.seek(0)
        file_FIFO.writelines(lines_FIFO)
        file_FIFO.truncate()
        file_FIFO.close()      

        
if __name__ == "__main__":
    program = NoC_Configurator()
    program.init()
    program.execute()
