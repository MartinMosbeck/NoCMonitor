#!/bin/python3
from PyQt5 import QtCore, QtGui, QtWidgets
from configNoC import Ui_configNoC
from configPE import Ui_configPE
from mainWindow import Ui_mainWindow
import sys
import math
import string
from enum import Enum

class MyTemplate(string.Template):
    delimiter = "%%"

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
        self.default_traffic = Traffic_Patterns.random

    def new_config(self):
        self.configNoC = QtWidgets.QDialog()
        self.configNoC_ui = Ui_configNoC()
        self.configNoC_ui.setupUi(self.configNoC)
        self.configNoC.show()
        self.configNoC.accepted.connect(lambda: self.new_config_accepted(self.configNoC_ui))

    def new_config_accepted(self,configNoC_ui):
        self.mesh_configured = True
        self.mesh_height = configNoC_ui.mesh_height.value()
        self.mesh_width = configNoC_ui.mesh_width.value()
        self.connect_directory = configNoC_ui.connect_directory.text()
        self.flit_data_width = configNoC_ui.flit_data_width.value()
        self.flit_buffer_depth = configNoC_ui.flit_buffer_depth.value()
        self.default_traffic = Traffic_Patterns(configNoC_ui.default_traffic.currentIndex())

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
            self.PE_button[i].clicked.connect(lambda: self.configurePE(i))

        num = 0

        for row in range(self.mesh_height-1,-1,-1):
            for column in range(0,self.mesh_width):
                self.mainWindow_ui.gridLayout.addWidget(self.PE_button[num], row, column)
                num = num+1

    def setPEDefaults(self):
        #TODO: handle random and manulal
        self.PE_pattern = []
        self.PE_dest = []
        self.PE_duty = []

        for i in range (0,self.mesh_width*self.mesh_height):
            self.PE_pattern.append(self.default_traffic)
            self.PE_dest.append(self.pattern_to_dest(self.default_traffic))
            self.PE_duty.append(50)                        

    def configurePE(self,X):
        self.configPE = QtWidgets.QDialog()
        self.configPE_ui = Ui_configPE()
        self.configPE_ui.setupUi(self.configPE)
        self.setValues_PEui(self.configPE_ui,X)
        self.configPE.accepted.connect(lambda: self.PE_config_accepted(self.configPE_ui,X))
        self.configPE.show()

    def setValues_PEui(self,ui,X):
        #TODO: handle random and manulal
        ui.traffic_pattern.setCurrentIndex(self.PE_pattern[X].value)
        ui.implied_destination.setText(str(self.PE_dest[X]))
        ui.duty_cycle.setValue(self.PE_duty[X])

    def PE_config_accepted(self,ui,X):
        #TODO: handle random and manulal
        self.PE_pattern[X] = Traffic_Patterns(ui.traffic_pattern.currentIndex())
        self.PE_dest[X] = self.pattern_to_dest(self.PE_pattern[X])
        self.PE_duty[X] = ui.duty_cycle.value()

    def pattern_to_dest(self,pattern):
        return 1

    def create_Files(self):
        #create PE_X files
        filename_tmp="../../templates/PE_X.temp"
        for i in range(0,self.mesh_width*self.mesh_height):
            parameters={"X":str(i),"DEST":str(self.PE_dest[i]),"DUTY_PERIOD":str(math.ceil(100/self.PE_duty[i]))}
         
            with open (filename_tmp, "r") as template_file:
                data=template_file.read()

            filename_out =self.connect_directory+"/"+"PE_{0}.v".format(i)
            with open (filename_out, "w") as output_file:
                s = MyTemplate(data)
                output_file.write(s.substitute(parameters)) 

        '''
        #create connecting wires
        connections = ""
        filename_tmp="../../templates/connection.temp"
        for i in range(0,self.mesh_width*self.mesh_height):
            parameters={"X":str(i)}
         
            with open (filename_tmp, "r") as template_file:
                data=template_file.read()

            s = MyTemplate(data)
            s.substitute(parameters)
            connections=connections+s

        #create PE instantiations
        create_PEs = ""
        filename_tmp="../../templates/create_PE.temp"
        for i in range(0,self.mesh_width*self.mesh_height):
            parameters={"X":str(i)}
         
            with open (filename_tmp, "r") as template_file:
                data=template_file.read()

            s = MyTemplate(data)
            output_file.write(s.substitute(parameters)) 
            createPEs=createPEs+s

        mappings_mkNetwork=""
        filename_tmp="mapping_MkNetwork.temp"
        for i in range(0,self.mesh_width*self.mesh_height):
            parameters={"X":str(i)}
         
            with open (filename_tmp, "r") as template_file:
                data=template_file.read()

            s = MyTemplate(data)
            output_file.write(s.substitute(parameters)) 
            mappings_mkNetwork=mappings_mkNetwork+s

        #create testbench
        filename_tmp="../../templates/testbench.temp"
        parameters={"CONNECTIONS":connections,"CREATE_PEs":createPEs,"MAPPINGS_mkNetwork":mappings_mkNetwork}
         
        with open (filename_tmp, "r") as template_file:
            data=template_file.read()

        filename_out =self.connect_directory+"/testbench.v"
        with open (filename_out, "w") as output_file:
            s = MyTemplate(data)
            output_file.write(s.substitute(parameters))
        '''
        

                

if __name__ == "__main__":
    program = NoC_Configurator()
    program.init()
    program.execute()
