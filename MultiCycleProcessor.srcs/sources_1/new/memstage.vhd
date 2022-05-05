library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity memstage is
    Port (
        -- Entity inputs 
        ByteOp : in std_logic;
        Mem_WrEn : in std_logic;
        ALU_MEM_Addr: in std_logic_vector(31 downto 0);
        MEM_DataIn: in std_logic_vector(31 downto 0);
        MM_RdData: in std_logic_vector(31 downto 0);

        -- Entity outputs
        MEM_DataOut: out std_logic_vector(31 downto 0);
        MM_WrEn: out std_logic;
        MM_Addr: out std_logic_vector(31 downto 0);
        MM_WrData: out std_logic_vector(31 downto 0)
    );
end memstage;

architecture Behavioral of memstage is   

begin

    MM_Addr <= ALU_MEM_Addr + x"400"; 
    MM_WrEn <= Mem_WrEn;
    
    -- ByteOp = 0 => lw or sw
    -- ByteOp = 1 => lb or sb
    MEM_DataOut <= MM_RdData when ByteOp = '0' else x"000000" & MM_RdData(7 downto 0) when ByteOp = '1';
    MM_WrData <= MEM_DataIn when ByteOp = '0' else x"000000" & MEM_DataIn(7 downto 0) when ByteOp = '1';
    
end Behavioral;
