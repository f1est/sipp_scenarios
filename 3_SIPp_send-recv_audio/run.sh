#!/bin/bash

# NOTE!!! Please run script from folder ./logs

#-------------------------------------------------------------------

# in this scenario used:
# - 3pcc extended scenario => exchange parameters between twins
# - handling calls via proxies (with Record-Route <=> Route headers). See rrs="true" attribute in a recv command, and [routes] keyword in send command
# - regexp and search headers in sip message
# - parsing branch parameter in Via-header
# - get rid of a mistake unused variable like this: "Variable $2 is referenced 1 times!
# - rtp-echo with change rtp-port

#-------------------------------------------------------------------

# Flow BUG:
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
# ===rcv===> 500 (or 491) --- to socket_2               --> uac2.xml         
# <==send=== ACK(500/491) --- from socket_2        --> uac2.xml         

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

#-------------------------------------------------------------------

# Flow FIXED:
# <==send=== REGISTER to 10.62.22.119:5060     --> uac_register.xml

# <==send=== INVITE --- from socket_1          --> uac1.xml
# ===rcv===> 100 --- to socket_1               --> uac1.xml
# ===rcv===> 200 --- to socket_1               --> uac1.xml
# ===rcv===> 200 --- to socket_1               --> uac1.xml
# ===rcv===> 200 --- to socket_1               --> uac1.xml
# ===rcv===> 200 --- to socket_1               --> uac1.xml
# ===rcv===> 200 --- to socket_1               --> uac1.xml
# <==send=== ACK --- from socket_1             --> uac1.xml

# <==send=== re-INVITE 1 --- from socket_1       --> uac1.xml
# ===rcv===> 100 --- to socket_1               --> uac1.xml
# ===rcv===> 200 --- to socket_1               --> uac1.xml
# ===rcv===> 200 --- to socket_1               --> uac1.xml
# ===rcv===> 200 --- to socket_1               --> uac1.xml

# sendCmd        --- from socket_0_1 to socket_0_2  --> uac1.xml         
# recvCmd        --- from socket_0_1 to socket_0_2  --> uac2.xml         

# <==send=== re-INVITE 2 --- from socket_2       --> uac2.xml         
# ===rcv===> 200 --- to socket_2               --> uac2.xml         
# <==send=== ACK(200) --- from socket_2        --> uac2.xml         

# ===rcv===> Bye --- from socket_2               --> uac2.xml
# <==send=== 200 --- from socket_2               --> uac2.xml


sipp -m 1 -p 5088 -trace_msg -trace_err -trace_logs -sf ../uac_register.xml 10.62.22.119:5060
sipp -m 1 -p 5099 -rtp_echo -mp 10020 -trace_msg -trace_err -trace_logs -sf ../uac2.xml 10.62.22.119:5060 -slave_cfg ../3PCC_Extended_IP_Addresses_slave.cfg -slave s1 -bg
sipp -m 1 -p 5088 -rtp_echo -mp 10000 -trace_msg -trace_err -trace_logs -sf ../uac1.xml 10.62.22.119:5060 -slave_cfg ../3PCC_Extended_IP_Addresses_master.cfg -master m

#sipp -m 1 -p 5099 -rtp_echo -mp 10020 -trace_msg -trace_err -trace_logs -sf ../uac2.xml 10.0.2.2:5070 -slave_cfg ../3PCC_Extended_IP_Addresses_slave.cfg -slave s1 -bg 
#sipp -m 1 -p 5088 -rtp_echo -mp 10000 -trace_msg -trace_err -trace_logs -sf ../uac1.xml 10.0.2.2:5070 -slave_cfg ../3PCC_Extended_IP_Addresses_master.cfg -master m
