#!/bin/bash

# 
#	author		f1est
#	telegram:	@F1estas (https://t.me/F1estas)
#	e-mail:		www-b@mail.ru
#

# NOTE!!! Please run script from folder ./logs

# Flow:

# <==send=== REGISTER  10.62.22.119:5060   --> uac_register.xml
# ===rcv===> INVITE                        --> uas1.xml
# <==send=== 180
# <==send=== 200
# ===rcv===> ACK
# <==send=== re-INVITE
# ===rcv===> 100
# ===rcv===> 180
# ===rcv===> 183
# ===rcv===> 200
# <==send=== ACK

# in loop
# ===rcv===> INVITE                        --> uas2.xml
# <==send=== 180
# <==send=== 200
# ===rcv===> ACK


sipp -m 1 -p 5088 -trace_msg -trace_err -trace_logs -sf ../my_tests/uac_register.xml 10.62.22.119:5060
sipp -m 1 -p 5088 -trace_msg -trace_err -trace_logs -sf ../my_tests/uas1.xml 10.62.22.119:5060
sipp -p 5088 -trace_msg -trace_err -trace_logs -sf ../my_tests/uas2.xml 10.62.22.119:5060
