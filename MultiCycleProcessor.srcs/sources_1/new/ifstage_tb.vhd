---------------------------------------------------------------------------------- 
-- Engineer: Dimitrios Petrou       
-- Create Date: 03/11/2022 02:49:28 PM
-- Module Name: IFSTAGE - Behavioral Module Testbench
-- Project Name: SingleCycleProcessor
-- Revision 1.00 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ifstage_tb is
end ifstage_tb;

architecture Behavioral of ifstage_tb is
    
    component ifstage is
        Port (
            -- Component inputs
            PC_Immed: in std_logic_vector(31 downto 0);
            PC_sel: in std_logic;
            PC_LdEn: in std_logic;
            RST: in std_logic;
            CLK: in std_logic;
            -- Component outputs
            PC: out std_logic_vector(31 downto 0)
        );
    end component ifstage;

signal PC_Immed,PC: std_logic_vector(31 downto 0);
signal PC_sel, PC_LdEn, RST, CLK, inner_termin : std_logic;

begin
    
    uut: ifstage PORT MAP(
        PC_Immed=>PC_Immed,
        PC_sel=>PC_sel,
        PC_LdEn=>PC_LdEn,
        RST=>RST,
        CLK=>CLK,
        PC=>PC
    );
    
    
    simProcess: process begin
        
        -- Reset the register
        RST<='1';
        PC_LdEn<='0';
        PC_sel<='0';
        wait for 100ns;
        
        
        -- Testing simple incrementor without LdEn high
        RST<='0';
        PC_LdEn<='0';
        PC_sel<='0';
        wait for 100ns;
        
        -- Testing simple incrementor without LdEn high
        RST<='0';
        PC_LdEn<='1';
        PC_sel<='0';
        wait for 200ns;
        
        -- Testing immediate incrementor
        PC_Immed<=x"00000007";
        PC_sel<='1';
        wait for 100ns;
        
        -- Testing simple incrementor while having Immed in input
        PC_sel<='0';
        wait for 100ns;
        
        
                        
        wait;     
    end process simProcess;

     --Process for generating clock signal 
    clkProcess: process begin
        --Vary the clock signal for low to high every 30ns 
        --Period = 100ns
        CLK <= '0';
        wait for 50ns;
        CLK <= '1';
        wait for 50ns;
        
        --The terminationg flag will be HIGH after a certain time 
        --The clock is generated for this amount of time 
        inner_termin<='1' after 3000ns;
        
        --Checking if we should terminate the clock generation
        if inner_termin ='1' then
            CLK<='0';  --Set clock signal to low 
            wait; --End the clock generation process
        end if;
    end process;
    
end Behavioral;
