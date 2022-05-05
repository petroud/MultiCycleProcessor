library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_tb is
end control_tb;

architecture Behavioral of control_tb is

    component control is 
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
    end component control;

signal tALU_zero, tPC_sel, tPC_LdEn, tALU_bin_sel, tRF_WrEn, tRF_B_sel, tRF_WrData_sel, tMem_WrEn, tByteOp: std_logic;
signal tInstr: std_logic_vector(31 downto 0);
signal tALU_func: std_logic_vector(3 downto 0);
signal tImmExt: std_logic_vector(1 downto 0);

begin
     
     uut: control PORT MAP(
        Instr => tInstr,
        ALU_zero => tALU_zero,
        
        PC_sel => tPC_sel,
        PC_LdEn => tPC_LdEn,
        ALU_func => tALU_func,
        ALU_bin_sel => tALU_bin_sel,
        RF_WrEn => tRF_WrEn,
        RF_B_sel => tRF_B_sel,
        RF_WrData_sel => tRF_WrData_sel,
        ImmExt => tImmExt,
        Mem_WrEn => tMem_WrEn,
        ByteOp => tByteOp
     );

     simProcess: process begin
        
        --  addi r5,r0,8
        tInstr <= "110000" & "00000" & "00101" & "0000000000001000";
        tALU_zero <= '-';
        wait for 100ns;
        
        -- ori r3,r0,ABCD
        tInstr <= "110011" & "00000" & "00011" & "1010101111001101";
        tALU_zero <= '-';
        wait for 100ns;
        
        -- sw r3,4(r0)
        tInstr <= "011111" & "00000" & "00011" & "0000000000000100";
        tALU_zero <= '-';
        wait for 100ns;
        
        -- lw r10,-4(r5)
        tInstr <= "001111" & "00101" & "01010" & "1111111111111100";
        tALU_zero <= '-';
        wait for 100ns; 
        
        -- lb r16,4(r0)
        tInstr <= "000011" & "00000" & "10000" & "0000000000000100";
        tALU_zero <= '-';
        wait for 100ns;
        
        -- nand r4,r10,r16 
        tInstr <= "100000" & "01010" & "00100" & "10000" & "00000" & "110101";
        tALU_zero <= '-';
        wait for 100ns;
          
        -- bne r5,r5,8
        tInstr <= "000001" & "00101" & "00101" & "0000000000001000";
        tALU_zero <= '0';
        wait for 100ns;
        
        -- bne r5,r5,8
        tInstr <= "000001" & "00101" & "00101" & "0000000000001000";
        tALU_zero <= '1';
        wait for 100ns;
        
        -- b -2
        tInstr <= "111111" & "00000" & "00000" & "1111111111111110";
        tALU_zero <= '-';
        wait for 100ns;
        
        -- addi r1,r0,1 
        tInstr <= "110000" & "00000" & "00001" & 
"00000" & "00000" & "000001";
        tALU_zero <= '-';
        wait for 100ns;
        
        wait;     
     end process simProcess;


end Behavioral;
