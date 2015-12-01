#!/bin/python3
from PyQt5 import QtCore, QtGui, QtWidgets
from configNoC import Ui_configNoC
from configPE import Ui_configPE
from mainWindow import Ui_mainWindow
import sys
import math
import string
from enum import Enum
from BitVector import *

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
        self.default_traffic_pattern = Traffic_Patterns.random
        self.default_packet_injection_rate = 0.1
        self.default_flits_per_packet = 1

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
            self.PE_button[i].clicked.connect(lambda: self.configurePE(i))

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

        for i in range (0,self.mesh_width*self.mesh_height):
            self.PE_traffic_pattern.append(self.default_traffic_pattern)
            self.PE_dest.append(self.pattern_to_dest(self.default_traffic_pattern,i))
            self.PE_packet_injection_rate.append(self.default_packet_injection_rate)
            self.PE_flits_per_packet.append(self.default_flits_per_packet)                        

    def configurePE(self,X):
        self.configPE = QtWidgets.QDialog()
        self.configPE_ui = Ui_configPE()
        self.configPE_ui.setupUi(self.configPE)
        self.setValues_PEui(self.configPE_ui,X)
        self.configPE.accepted.connect(lambda: self.PE_config_accepted(self.configPE_ui,X))
        self.configPE.show()

    def setValues_PEui(self,ui,X):
        #TODO: handle random and manulal
        ui.PE_label.setText("PE_{0} Parameters".format(X))
        ui.traffic_pattern.setCurrentIndex(self.PE_traffic_pattern[X].value)
        ui.implied_destination.setText(str(self.PE_dest[X]))
        ui.packet_injection_rate.setValue(self.PE_packet_injection_rate[X])
        ui.flits_per_packet.setValue(self.PE_flits_per_packet[X])

    def PE_config_accepted(self,ui,X):
        #TODO: handle random and manulal
        self.PE_traffic_pattern[X] = Traffic_Patterns(ui.traffic_pattern.currentIndex())
        self.PE_dest[X] = self.pattern_to_dest(self.PE_traffic_pattern[X],X)
        self.PE_packet_injection_rate[X] = ui.packet_injection_rate.value()
        self.PE_flits_per_packet[X] = ui.flits_per_packet.value()

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

    def create_Files(self):
        return 0
        

                

if __name__ == "__main__":
    program = NoC_Configurator()
    program.init()
    program.execute()
