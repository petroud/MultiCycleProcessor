library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control is
    Port (
        -- Entity inputs
        Instr: in std_logic_vector(31 downto 0);
        ALU_zero: in std_logic;
        
        -- Entity outputs
        PC_sel: out std_logic;
        PC_LdEn: out std_logic;
        ALU_func: out std_logic_vector(3 downto 0);
        ALU_bin_sel: out std_logic;
        RF_WrEn: out std_logic;
        RF_B_sel: out std_logic;
        RF_WrData_sel: out std_logic;
        ImmExt: out std_logic_vector(1 downto 0);
        Mem_WrEn: out std_logic;
        ByteOp: out std_logic        
    );
end control;

architecture Behavioral of control is


signal controlBus: std_logic_vector(13 downto 0);

------ CONTROL BUS ------
-- MSB 
-- b13 -> PC_sel
-- b12 -> PC_LdEn
-- b11 -> ALU_func(3)
-- b10 -> ALU_func(2)
-- b09 -> ALU_func(1)
-- b08 -> ALU_func(0)
-- b07 -> ALU_bin_sel
-- b06 -> RF_WrEn
-- b05 -> RF_B_sel
-- b04 -> RF_WrData_sel
-- b03 -> ImmExt(1)
-- b02 -> ImmExt(0)
-- b01 -> Mem_WrEn
-- b00 -> ByteOp
-- LSB
-------------------------

begin
    -- Register Instructions
    controlBus <= "01" & Instr(3 downto 0) & "0101--0-" when (Instr(31 downto 26)="100000") else
    
    -- Immediate Instructions
                   -- ADDI or LI (Addition with Register or Addition with R0 and Sign Extend for the Immediate)
                  "01" & "0000" & "1111" & "01" & "0-" when (Instr(31 downto 30)="11" AND Instr(28 downto 26)="000") else
                   -- LUI 
                  "01" & "0000" & "1111" & "11" & "0-" when (Instr(31 downto 30)="11" AND Instr(28 downto 26)="001") else
                   -- NANDI
                  "01" & "0101" & "1111" & "00" & "0-" when (Instr(31 downto 30)="11" AND Instr(28 downto 26)="010") else
                   -- ORI 
                  "01" & "0011" & "1111" & "00" & "0-" when (Instr(31 downto 30)="11" AND Instr(28 downto 26)="011") else                
               
    -- Branch Instructions
                  -- B (simple branch to Immediate address)
                  "11" & "----" & "011-" & "10" & "0-" when (Instr(31 downto 26)="111111") else
                  -- BEQ OR BNE (branch equal based on equality with 0 of the subtraction result of operand registers)
                  -- PC_sel value is decided by the 26th bit of the Instruction and the ALU_zero flag
                  -- When ALU_zero flag is '1' we have equality 
                  --    |-> So if the instr is beq (0) then PC_sel must be '1' to jump
                  --    |-> So if the instr is bne (1) then PC_sel must be '0' to not jump
                  -- When ALU_zero flag is '0' we do not have equality
                  --    |-> So if the instr is beq (0) then PC_sel must be '0' to not nump
                  --    |-> So if the instr is bne (1) thne PC_sel must be '1' to jump 
                  -- The truth table is
                  --
                  -- ZFlag,INS | PC_sel
                  -- -------------------
                  --   1    0  |   1 
                  --   1    1  |   0
                  --   0    0  |   0
                  --   0    1  |   1
                  --   
                  (ALU_zero XOR Instr(26)) & '1' & "0001" & "011-" & "10" & "0-" when (Instr(31 downto 26) = "000000" OR Instr(31 downto 26)="000001") else
    
    -- Memory transactions instructions (load & store)
                --LW and LB 
                  "01" & "0000" & "1100" & "01" & '0' & (Instr(29) NAND Instr(28)) when (Instr(31 downto 26) = "000011" OR Instr(31 downto 26) = "001111") else
                --SW and SB
                  "01" & "0000" & "1010" & "01" & '1' & (Instr(29) NAND Instr(28)) when (Instr(31 downto 26) = "000111" OR Instr(31 downto 26) = "011111");
    
    
    PC_sel <= controlBus(13);
    PC_LdEn <= controlBus(12);
    ALU_func <= controlBus(11 downto 8);
    ALU_bin_sel <= controlBus(7);
    RF_WrEn <= controlBus(6);
    RF_B_sel <= controlBus(5);
    RF_WrData_sel <= controlBus(4);
    ImmExt <= controlBus(3 downto 2);
    Mem_WrEn <= controlBus(1);
    ByteOp <= controlBus(0); 
    
        
end Behavioral;
