# Table
NEW Table { TEST, TEST2, TEST3 }

SIZ Table TableSize

# Loop Counter
NEW Counter 0
NEW Increment 1

NEW Finished 0

NEW Text Total Increment:
NEW \n \n

# Loop
REG Loop 17

TBLD Table 1
ADD Counter Increment Counter
AND Counter TableSize Finished
JNZ 24 Finished

JMP Loop

# Print
CAP print print

SYS print Text Counter

# Print Table
CAP PrintTable PrintTable

SYS PrintTable Table

# Clear Cache
RBL