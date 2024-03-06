import torch
import torch.nn as nn
import queue
import hashlib

class Maze(nn.Module):
    pass

maze=torch.load('./maze.pt')

mymat=maze.state_dict()['maze.weight'].tolist()
mazelen=len(mymat)

class node():
    def __init__(self,x,y,path):
        self.x=x
        self.y=y
        self.path=path

def bfs(x,y,path):
    used=[[False]*mazelen for k in range(mazelen)]
    dy=[1,-1,0,0]
    dx=[0,0,1,-1]
    dir=['D','A','S','W']
    q=queue.Queue()
    start=node(x,y,path)
    q.put(start)
    used[x][y]=True
    while(q.empty()==False):
        now=q.get()
        nowx,nowy,nowpath=now.x,now.y,now.path
        if(mymat[nowx][nowy]==3):
            print(nowpath)
            m=hashlib.md5()
            m.update(nowpath.encode())
            print('flag{'+m.hexdigest()+'}')

        for i in range(len(dir)):
            tmpx=nowx+dx[i]
            tmpy=nowy+dy[i]
            tmppath=nowpath+dir[i]
            if(tmpx>=0 and tmpx<mazelen and tmpy>=0 and tmpy<mazelen and (mymat[tmpx][tmpy]==0 or mymat[tmpx][tmpy]==3) and used[tmpx][tmpy]==False):
                used[tmpx][tmpy]=True
                q.put(node(tmpx,tmpy,tmppath))
bfs(1,0,'')