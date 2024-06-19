ADDI A, 32 (00100000)
MOV R7, A
-- registrador 7 recebe 32

LD    A, 0
MOV   R6, A
-- registrador 6 recebe 0

ADDI  A, 1
MOV  R1, A
-- registrador 1 recebe 1 - contador

SW   R1, 0(A) 
CMP  A, R7
BLT  -4
-- volta pro addi se A = R7

LD A, 1
MOV R1, A

-- Comeca o loop externo

MOV A, R1
ADDI A, 1
MOV R1, A     
MOV R2, A  

LW R4, 0(A)
SUB A, R4
BNE -6  

LD  A, 1
MOV  R3, A

-- Comeca o loop interno

MOV A, R3
ADDI A, 1
MOV R3, A

MOV A, R1
ADD R2, A   

MOV A, R2
SW  R0, 0(A)

CMP A, R7  -- Pula se for menor

MOV A, R1
CMP A, R3  -- Pula se for menor

LI A, 1
MOV R6, A 

MOV A, R2
CMP A, R7 
BNE (-16)

-- Fim loop interno

MOV A, R6
CMP A, R0 -- Verifica se finalizou
BEQ (-25)

-- Fim loop externo

MOV A, R7
LW  R5, 0(A)