----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:11:19 08/28/2015 
-- Design Name: 
-- Module Name:    CircularBuffer_Datapath - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.STD_SAD.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CircularBuffer_Datapath is
	Port(
		CLK			: in STD_LOGIC;
		START			: in STD_LOGIC;
		writeCache	: in STD_LOGIC;
		curVecX		: in STD_LOGIC_VECTOR(7 downto 0);
		curVecY		: in STD_LOGIC_VECTOR(7 downto 0);
		vecFound		: out STD_LOGIC
	);
end CircularBuffer_Datapath;

architecture Behavioral of CircularBuffer_Datapath is

signal cache: circ_buffer;
signal index: STD_LOGIC_VECTOR(3 downto 0);
signal bitsFound: STD_LOGIC_VECTOR(15 downto 0);
signal concatVecXY: STD_LOGIC_VECTOR(15 downto 0);
signal regVecFound: STD_LOGIC;
signal hasFoundVec: STD_LOGIC;

signal regCurVecXByPass, regCurVecYByPass: STD_LOGIC_VECTOR(7 downto 0);

begin

vecFound <= regVecFound;

	process(START, CLK)
	begin
		if(START = '0') then
			index <= (OTHERS=>'0');
			regVecFound <= '0';
			regCurVecXByPass <= (OTHERS=>'0');
			regCurVecYByPass <= (OTHERS=>'0');
			for i in 0 to 14 loop
				cache(i) <= "01010110010101011";
				cache(i+1) <= "01010101010101101";
			end loop;
			cache(12) <= "01010100010101011";
			cache(13) <= "01010011010101011";
		elsif(CLK'event and CLK = '1') then
			regVecFound <= hasFoundVec;
			if(writeCache = '1') then
				cache(to_integer(unsigned(index))) <= regCurVecXByPass & regCurVecYByPass & '1';
				index <= index + 1;
			end if;
			regCurVecXByPass <= curVecX;
			regCurVecYByPass <= curVecY;
		end if;
	end process;
	
concatVecXY <= curVecX & curVecY;

COMP: for i in 0 to 15 generate
	bitsFound(i) <= '1' when ((concatVecXY & '1') = cache(i)) else
						 '0';
end generate COMP;

--	COMP: for i in 0 to 15 generate
--		COMP2: for j in 0 to 15 generate
--			comparison(j) <= cache(i)(j) xor concatVecXY(j);
--		end generate COMP2;
--		bitsFound(i) <= comparison(15) and comparison(14) and comparison(13) and comparison(12) and comparison(11) and 
--		comparison(10) and comparison(9) and comparison(8) and comparison(7) and comparison(6) and comparison(5) and 
--		comparison(4) and comparison(3) and comparison(2) and comparison(1) and comparison(0) and cache(i)(16);
--	end generate COMP;

hasFoundVec <= '0' when bitsFound = "0000000000000000" else
				'1';

end Behavioral;