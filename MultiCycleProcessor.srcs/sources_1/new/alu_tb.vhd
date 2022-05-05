---------------------------------------------------------------------------------- 
-- Engineer: Dimitrios Petrou       
-- Create Date: 03/11/2022 02:49:50 PM
-- Module Name: alu - Testbench 
-- Project Name: SingleCycleProcessor
-- Revision 1.00 - Testbench Completed and Quality Checks performed
----------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_tb is
end alu_tb;

architecture Behavioral of alu_tb is
    component alu 
        port(
             --Component inputs
             A: in std_logic_vector(31 downto 0);
             B: in std_logic_vector(31 downto 0);
             Op: in std_logic_vector(3 downto 0);
             --Component outputs
             Output: out std_logic_vector(31 downto 0);
             Zero: out std_logic;
             Cout: out std_logic;
             Ovf: out std_logic
        );
    end component;
    
    --Local signals 
    signal A: std_logic_vector(31 downto 0) := (others => '0');
    signal B: std_logic_vector(31 downto 0) := (others => '0');
    signal Op: std_logic_vector(3 downto 0) := (others => '0');
    
    signal Output: std_logic_vector(31 downto 0);
    signal Zero: std_logic;
    signal Ovf: std_logic;
    signal Cout: std_logic;
    
    begin
    
        uut: alu 
        PORT MAP(
            A=>A,
            B=>B,
            Op=>Op,
            Output=>Output,
            Zero => Zero,
            Cout => Cout,
            Ovf => Ovf            
        );
    
    
    simProcess: process begin
        
		------------ Testing the sum operation ------------
        Op <= "0000";
        
        --Zero input
        A <= "00000000000000000000000000000000";
		B <= "00000000000000000000000000000000";
		wait for 100 ns;
		
		-- 1+1
        A <= "00000000000000000000000000000001";
		B <= "00000000000000000000000000000001";
		wait for 100 ns;
		
		-- 1+(-1)
        A <= "00000000000000000000000000000001";
		B <= "11111111111111111111111111111111";
		wait for 100 ns;
		
		-- 5232041+95488342
		-- Average Case
        A <= "00000000010011111101010110101001";
		B <= "00000101101100010000100101010110";
		wait for 100 ns;
		
		-- 5232041+(-95488342)
		-- Average Case
        A <= "00000000010011111101010110101001";
		B <= "11111010010011101111011010101010";
		wait for 100 ns;
			
		-- 2.147.483.647 + 1
		-- Edge Case
        A <= "01111111111111111111111111111111";
		B <= "00000000000000000000000000000001";
		wait for 100 ns;
			
		-- 4 + (-3)
        A <= "00000000000000000000000000000100";
		B <= "11111111111111111111111111111101";
		wait for 100 ns;
		
		-- 2.147.483.647 + (-2.147.483.648)
        A <= "01111111111111111111111111111111";
		B <= "10000000000000000000000000000000";
		wait for 100 ns;
		
		-- 2.147.483.647 + (-2.147.483.647)
        A <= "01111111111111111111111111111111";
		B <= "10000000000000000000000000000001";
		wait for 100 ns;
		
		
		A<=x"00000000";
		B<=x"00000000";
		wait for 200ns;
		
		
		------------ Testing the substraction operation ------------
		Op <= "0001";
		-- 2.147.483.647 - 2.147.483.647
        A <= "01111111111111111111111111111111";
		B <= "01111111111111111111111111111111";
		wait for 100ns;
		
		Op <= "0001";
		-- 2.147.483.647 - (-2.147.483.647)
		-- Edge case
        A <= "01111111111111111111111111111111";
		B <= "10000000000000000000000000000001";
		wait for 100ns;
		
		Op <= "0001";
		-- 2.147.483.647 - 1.147.483.647
		-- Average case
        A <= "01111111111111111111111111111111";
		B <= "01000100011001010011010111111111";
		wait for 100ns;
		
		------------ Testing the AND operation ------------
		Op <= "0010";
        A <= "00010101010010010110001010101000";
		B <= "01000100011001010011010111111111";
		wait for 100ns;
		
		------------ Testing the OR operation ------------
		Op <= "0011";
        A <= "01111111111111111111111111111111";
		B <= "01000100011001010011010111111111";
		wait for 100ns;	
		
		Op <= "0011";
        A <= "01111111111111111111111111111111";
		B <= "01111111111111111111111111111111";
		wait for 100ns;
		
		------------ Testing the NOT operation ------------
		Op <= "0100";
        A <= x"7fffffff";
		B <= x"00000000";
		wait for 100ns;
		
		------------ Testing the NAND operation ------------
		Op <= "0110";
        A <= "00010101010010010110001010101000";
		B <= "01000100011001010011010111111111";
		wait for 100ns;
		
		------------ Testing the SR arithmetic operation ------------
		Op <= "1000";
        A <= x"f1ffffff";
		B <= x"00000000";
		wait for 100ns;
		
		Op <= "1000";
        A <= x"7fffffff";
		B <= x"00000000";
		wait for 100ns;
		
		------------ Testing the SR logic operation ------------
		Op <= "1001";
        A <= x"7fff7f3f";
		B <= x"00000000";
		wait for 100ns;
		
		
		------------ Testing the SL logic operation ------------
		Op <= "1010";
		A <= x"3f0fffff";
		B <= x"00000000";
		wait for 100ns;
		
		
		------------ Testing the Rotate Left opearation ------------
		Op <= "1100";
        A <= x"fffffff0";
        B <= x"00000000";
        wait for 100ns;
		
		
		------------ Testing the Rotate Right operation ------------
		Op <= "1101";
		A <= x"00fffffb";
		B <= x"00000000";
		wait for 100ns;	    
	    

        wait;
   end process;

end Behavioral;
