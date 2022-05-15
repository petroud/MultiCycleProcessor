---------------------------------------------------------------------------------- 
-- Engineer: Dimitrios Petrou       
-- Create Date: 04/27/2022 09:15:44 PM
-- Module Name: Multi-Cycle control module testbench 
-- Project Name: MultiCycleProcessor
-- Revision 1.00 - Module implemented
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_mc_tb is
end control_mc_tb;

architecture Behavioral of control_mc_tb is

    component control_mc is
         Port (                                         
             -- Global Signals                          
             CLK: in std_logic;                         
             RST: in std_logic;                         
                                                        
             -- Entity inputs                           
             Instr: in std_logic_vector(31 downto 0);   
             ALU_zero: in std_logic;                    
                                                        
             -- Datapath Registers Control Signals      
             Instr_Reg_WrEn: out std_logic;             
             RF_A_Reg_WrEn: out std_logic;              
             RF_B_Reg_WrEn: out std_logic;              
             ALU_out_Reg_WrEn: out std_logic;           
             MEM_Reg_WrEn: out std_logic;               
                                                        
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
    end component;

signal CLK,RST,ALU_zero: std_logic;
signal Instr: std_logic_vector(31 downto 0);
signal Instr_Reg_WrEn, RF_A_Reg_WrEn, RF_B_Reg_WrEn, ALU_out_Reg_WrEn, MEM_Reg_WrEn: std_logic;
signal PC_sel, PC_LdEn, ALU_bin_sel, RF_WrEn, RF_B_sel, RF_WrData_sel, Mem_WrEn, ByteOp: std_logic;
signal ALU_func: std_logic_vector(3 downto 0);
signal ImmExt: std_logic_vector(1 downto 0);
signal inner_termin: std_logic;


begin
    
    uut: control_mc PORT MAP(
        CLK => CLK,
        RST => RST,
        Instr => Instr,
        ALU_zero => ALU_zero,
        
        Instr_Reg_WrEn => Instr_Reg_WrEn,
        RF_A_Reg_WrEn => RF_A_Reg_WrEn,
        RF_B_Reg_WrEn => RF_B_Reg_WrEn,
        ALU_out_Reg_WrEn => ALU_out_Reg_WrEn,
        MEM_Reg_WrEn => MEM_Reg_WrEn,
        
        PC_sel => PC_sel,
        PC_LdEn => PC_LdEn,
        ALU_func => ALU_func,
        ALU_bin_sel => ALU_bin_sel,
        RF_WrEn => RF_WrEn,
        RF_B_sel => RF_B_sel,
        RF_WrData_sel => RF_WrData_sel,
        ImmExt => ImmExt,
        Mem_WrEN => Mem_WrEn,
        ByteOp => Byteop        
    );
    
    
    simProcess: process begin
    
        RST <='1';
        wait for 20ns;
        RST <='0';
        ALU_zero <= '0';
        
        -- R-instruction
        Instr <="100000" & "000000" & "000000" & "00000000" & "110011";
        wait for 100ns;
        
        -- I-instruction        
        Instr <="111000" & "000000" & "000000" & "00000000" & "000000";
        wait for 100ns;
        
        -- b 
        Instr <="111111" & "000000" & "000000" & "00000000" & "000000";
        wait for 100ns;
        
        
        -- beq
        Instr <="000000" & "000000" & "000000" & "00000000" & "000000";
        ALU_zero <= '1';
        wait for 40ns;
        
        -- sb
        Instr <="000111" & "000000" & "000000" & "00000000" & "000000";
        wait for 100ns;
        
        -- lw
        Instr <="001111" & "000000" & "000000" & "00000000" & "000000";
        wait for 100ns;    
        
   
        wait;
    end process;
    
    
    
       --Process for generating clock signal 
    clkProcess: process begin
        --Vary the clock signal for low to high every 30ns 
        --Period = 20ns
        CLK <= '0';
        wait for 10ns;
        CLK <= '1';
        wait for 10ns;
        
        --The terminationg flag will be HIGH after a certain time 
        --The clock is generated for this amount of time 
        inner_termin<='1' after 800ns;
        
        --Checking if we should terminate the clock generation
        if inner_termin ='1' then
            CLK<='0';  --Set clock signal to low 
            wait; --End the clock generation process
        end if;
    end process;


end Behavioral;
