#!/bin/bash

# 
#	author		f1est
#	telegram:	@F1estas (https://t.me/F1estas)
#	e-mail:		www-b@mail.ru
#

# NOTE!!! Please run script from folder ./logs

#-------------------------------------------------------------------

# in this scenario used:
# - 3pcc extended scenario => exchange parameters between twins
# - handling calls via proxies (with Record-Route <=> Route headers). See rrs="true" attribute in a recv command, and [routes] keyword in send command
# - regexp and search headers in sip message
# - parsing branch parameter in Via-header
# - get rid of a mistake unused variable like this: "Variable $2 is referenced 1 times!

#-------------------------------------------------------------------

# Flow:
# <==send=== REGISTER to 10.62.22.119:5060     --> uac_register.xml

# <==send=== INVITE --- from socket_1          --> uac1.xml
# ===rcv===> 100 --- to socket_1               --> uac1.xml
# ===rcv===> 200 --- to socket_1               --> uac1.xml
# ===rcv===> 200 --- to socket_1               --> uac1.xml
# ===rcv===> 200 --- to socket_1               --> uac1.xml
# ===rcv===> 200 --- to socket_1               --> uac1.xml
# ===rcv===> 200 --- to socket_1               --> uac1.xml
# <==send=== ACK --- from socket_1             --> uac1.xml

# <==send=== re-INVITE --- from socket_1       --> uac1.xml
# ===rcv===> 100 --- to socket_1               --> uac1.xml
# ===rcv===> 200 --- to socket_1               --> uac1.xml
# ===rcv===> 200 --- to socket_1               --> uac1.xml
# ===rcv===> 200 --- to socket_1               --> uac1.xml

# sendCmd        --- from socket_0_1 to socket_0_2  --> uac1.xml         
# recvCmd        --- from socket_0_1 to socket_0_2  --> uac2.xml         

# <==send=== re-INVITE --- from socket_2       --> uac2.xml         
# ===rcv===> 500 --- to socket_2               --> uac2.xml         
# <==send=== ACK(500) --- from socket_2        --> uac2.xml         

# ===rcv===> 200 --- to socket_1
# ===rcv===> 200 --- to socket_1
# ===rcv===> 200 --- to socket_1
# ===rcv===> 200 --- to socket_1
# ===rcv===> 200 --- to socket_1

# ===rcv===> Bye --- from socket_2               --> uac2.xml
# <==send=== 481 --- from socket_2               --> uac2.xml

# ===rcv===> 200 --- to socket_1
# ===rcv===> 200 --- to socket_1
# ===rcv===> 200 --- to socket_1


sipp -m 1 -p 5088 -trace_msg -trace_err -trace_logs -sf ../uac_register.xml 10.62.22.119:5060
sipp -m 1 -p 5099 -trace_msg -trace_err -trace_logs -sf ../uac2.xml 10.62.22.119:5060 -slave_cfg ../3PCC_Extended_IP_Addresses_slave.cfg -slave s1 -bg
sipp -m 1 -p 5088 -trace_msg -trace_err -trace_logs -sf ../uac1.xml 10.62.22.119:5060 -slave_cfg ../3PCC_Extended_IP_Addresses_master.cfg -master m

