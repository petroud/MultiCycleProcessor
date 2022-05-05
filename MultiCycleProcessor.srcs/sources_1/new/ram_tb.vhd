---------------------------------------------------------------------------------- 
-- Engineer: Dimitrios Petrou       
-- Create Date: 03/11/2022 02:49:28 PM
-- Module Name: RAM - Testbench stand-alone
-- Project Name: SingleCycleProcessor
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ram_tb is
end ram_tb;

architecture Behavioral of ram_tb is
    
    component ram is
        port (
            --Component inputs
            clk : in std_logic;
            inst_addr : in std_logic_vector(10 downto 0);
            inst_dout : out std_logic_vector(31 downto 0);
            data_we : in std_logic;
            data_addr : in std_logic_vector(10 downto 0);
            data_din : in std_logic_vector(31 downto 0);
            --Component outputs
            data_dout : out std_logic_vector(31 downto 0)
        );
    end component;
    
signal inst_addr, data_addr : std_logic_vector(10 downto 0);
signal inst_dout, data_din, data_dout: std_logic_vector(31 downto 0);
signal clk,data_we,inner_termin : std_logic;

begin
    
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
        inner_termin<='1' after 5500ns;
        
        --Checking if we should terminate the clock generation
        if inner_termin ='1' then
            CLK<='0';  --Set clock signal to low 
            wait; --End the clock generation process
        end if;
    end process;
    
    --Port Mapping local signals 
    uut: RAM PORT MAP(
        clk=>clk,
        inst_addr=>inst_addr,
        inst_dout=>inst_dout,
        data_we=>data_we,
        data_addr=>data_addr,
        data_din=>data_din,
        data_dout=>data_dout
    );
    
    
    simProcess: process begin
    
        -- Initialize the signals
        data_we<='0';
        data_addr<="10000000000";
        data_din<=x"000000aa";
        inst_addr<="00000000000";
        wait for 100ns;
        
        -- Testing recalling instructions from memory
        for i in 0 to 7 loop
            inst_addr <= inst_addr+1;
            wait for 100ns;
        end loop;
        
        -- Testing writing words in the data section
        data_we<='1';
        for i in 0 to 3 loop
            data_din <= data_din+1;
            data_addr <= data_addr+1;
            wait for 100ns;
        end loop;
        
        -- Trying to read what we wrote before
        data_we<='0';
        data_addr <= "10000000000";
        wait for 100ns;
        
        for i in 0 to 3 loop
            data_addr <= data_addr+1;
            wait for 100ns;            
        end loop;
        
        wait;
    end process simProcess;
    
    
    --Simulation process


end Behavioral;
