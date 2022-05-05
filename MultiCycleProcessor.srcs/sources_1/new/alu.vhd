---------------------------------------------------------------------------------- 
-- Engineer: Dimitrios Petrou       
-- Create Date: 03/11/2022 02:49:28 PM
-- Module Name: alu - Behavioral
-- Project Name: SingleCycleProcessor
-- Revision 1.00 - ALU implemented and tested
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu is
    Port (
         --Entity inputs
         A: in std_logic_vector(31 downto 0);
         B: in std_logic_vector(31 downto 0);
         Op: in std_logic_vector(3 downto 0);
         --Entity outputs
         Output: out std_logic_vector(31 downto 0);
         Zero: out std_logic;
         Cout: out std_logic;
         Ovf: out std_logic
    );
end alu;

architecture Behavioral of alu is

signal local_Out: std_logic_vector(31 downto 0);
signal local_Cout: std_logic_vector(32 downto 0); --Using 33 bits to store potential carry after the operation
signal MSB_A: std_logic;
signal MSB_B: std_logic;
signal MSB_R: std_logic;
signal local_Ovf: std_logic;
signal local_Zero: std_logic;

begin
    process(A,B,Op,local_Out,local_Cout,local_Ovf,local_Zero,MSB_A,MSB_B,MSB_R)
    begin
        local_Cout <= ('0' & A) + ('0' & B);
        case Op is 
            --Add
            when "0000" =>
                local_Out <= A+B;
                --Cout length is 33 bits to store a potential carry so we need to execute
                --the operation with 33bit length operands. We prepend a 0 at each operand. 
            --Subtract
            when "0001" =>
                local_Out <= A-B;
                local_Cout <= ('0' & A) - ('0' & B);
            --AND
            when "0010" =>
                local_Out <= A AND B;
            --OR
            when "0011" =>
                local_Out <= A OR B;
            --Invert A
            when "0100" =>
                local_Out <= NOT A;
            --NAND
            when "0101" =>
                local_Out <= A NAND B;
            --NOR
            when "0110" =>
                local_Out <= A NOR B;
            --Shift right, new MSB = old MSB
            when "1000" =>
                local_Out(31) <= A(31);
                local_Out(30 downto 0) <= A(31 downto 1);
            --Shift right, new MSB = '0'
            when "1001" =>
                local_Out(31) <= '0';
                local_Out(30 downto 0) <= A(31 downto 1);
            --Shift left, new LSB = '0'
            when "1010" =>
                local_Out(0) <= '0';
                local_Out(31 downto 1) <= A(30 downto 0);
            --Rotate Left by 1 bit
            when "1100" =>
                local_Out(31 downto 1) <= A(30 downto 0);
                local_Out(0) <= A(31);
            --Rotate Right by 1 bit
            when "1101" =>
                local_Out(30 downto 0) <= A(31 downto 1);
                local_Out(31) <= A(0);
            when others => null;
        end case;
        -- Checks for output characterization --
        
        -- Check for overflow in the operation performed --
        -- We have 2 possible cases for overflow. Each of them has its own conditions 
        -- about the operands and the result. The cases are:
        --    -> Two positive operands produce negative result
        --    -> Two negative operands produce positive result
        -- We identify the sign of each operand by looking at the MSB
        MSB_A <= A(31);
        MSB_B <= B(31);
        MSB_R <= local_Out(31);
        
        if(Op="0000" AND ((MSB_A='1' AND MSB_B='1' AND MSB_R='0') OR (MSB_A='0' AND MSB_B='0' AND MSB_R='1'))) then
            local_Ovf <= '1';
        else 
            local_Ovf <= '0';
        end if;
        
        if(Op="0001" AND (A(31)/=B(31) AND local_Cout(31)/=A(31))) then
            local_Ovf <= '1';
        else
            local_Ovf <= '0';
        end if;
        
        -- Check for zero output result --
        if(local_Out = x"00000000" OR local_Ovf = '1') then
            local_Zero <= '1';
        else
            local_Zero <= '0';
        end if;

        -- Drive local signals tou module outputs
        
         --If overflow occured during the operation there is not legible result to present
        if(local_Ovf = '1') then
            Output <= x"00000000" after 10ns;
        else 
            Output <= local_Out   after 10ns;
        end if;     
        
        Cout <= local_Cout(32)  after 10ns;
        Ovf <= local_Ovf        after 10ns;
        Zero <= local_Zero      after 10ns;
    end process;
end Behavioral;
