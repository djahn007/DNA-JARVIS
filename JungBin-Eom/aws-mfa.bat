@echo off
 
setlocal ENABLEDELAYEDEXPANSION

set otp=%1

aws sts get-session-token --profile=ricky --serial-number="arn:aws:iam::042298199494:mfa/ricky" --token-code="%otp%" | sts2credentials --profile=ricky-mfa
