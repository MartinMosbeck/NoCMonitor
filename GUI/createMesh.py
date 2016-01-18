#!/usr/bin/env python3

class Node:
    def __init__(self,x,y,num):
        self.x = x
        self.y = y
        self.num = num

if __name__ == "__main__":
    top = open("mesh.top","w")
    routing = open("mesh.routing","w")
    
    xDim = 4
    yDim = 4
    mesh = [ [ None for i in range(yDim) ] for j in range(xDim) ]

    #create node and asign number and coordinate in matrix
    num = 0
    for y in range(yDim):
        for x in range(xDim):
            mesh[x][y] = Node(x,y,num)
            num = num + 1

    #set up the links from left to right
    for y in range(yDim):
        for x in range(0,xDim-1):
           top.write("RouterLink\tR{0}:3\t->\tR{1}:3\n".format(mesh[x][y].num,mesh[x+1][y].num))

    #set up the links from right to left
    for y in range(yDim):
        for x in range(xDim-1,0,-1):
           top.write("RouterLink\tR{0}:1\t->\tR{1}:1\n".format(mesh[x][y].num,mesh[x-1][y].num))

    #set up the links from down to up
    for x in range(xDim):
        for y in range(0,yDim-1):
           top.write("RouterLink\tR{0}:4\t->\tR{1}:4\n".format(mesh[x][y].num,mesh[x][y+1].num))

    #set up the links from top to down
    for x in range(xDim):
        for y in range(yDim-1,0,-1):
           top.write("RouterLink\tR{0}:2\t->\tR{1}:2\n".format(mesh[x][y].num,mesh[x][y-1].num))

    #connect the extra for stat
    top.write("RouterLink\tR{0}:3\t->\tR{1}:3\n".format(mesh[xDim-1][yDim-2].num,xDim*yDim))
    top.write("RouterLink\tR{0}:1\t->\tR{1}:1\n".format(xDim*yDim,mesh[xDim-1][yDim-2].num))

    #give everyone a Send and Recv
    for i in range(xDim*yDim+1):#was+ 1
        top.write("SendPort\t{0}\t->\tR{1}:0\n".format(i,i))
        top.write("RecvPort\t{0}\t->\tR{1}:0\n".format(i,i))
    
    top.close()


    #create routing tables
    for yElem in range(yDim):
        for xElem in range(xDim):
            #f=open("routing/mesh_routing{0}.hex".format(mesh[xElem][yElem].num),"w")
            toStat = 0
            for y in range(yDim):
                for x in range(xDim):
                    if(x < xElem):
                        port = 1
                    elif(x > xElem):
                        port = 3
                    elif(y < yElem):
                        port = 2
                    elif(y > yElem):
                        port = 4
                    else:
                        port = 0       
                    routing.write("R{0}:\t{1}\t->\t{2}\n".format(mesh[xElem][yElem].num,mesh[x][y].num,port))
                    #save for way to stat
                    if (x==xDim-1) and (y==yDim-2):
                        toStat = port
                        if(xElem==xDim-1) and (yElem==yDim-2):
                            toStat = 3
            # f.write(str(port)+"\n")
            #to STAT
            routing.write("R{0}:\t{1}\t->\t{2}\n".format(mesh[xElem][yElem].num,xDim*yDim,toStat))
    print("")

    #routing from STAT
    for y in range(yDim):
        for x in range(xDim):
             routing.write("R{0}:\t{1}\t->\t{2}\n".format(xDim*yDim,mesh[x][y].num,1))

    routing.close()
