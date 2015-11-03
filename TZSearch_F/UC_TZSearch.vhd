----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:19:27 10/01/2015 
-- Design Name: 
-- Module Name:    UC_TZSearch - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC_TZSearch is
	Port(
		CLK					: in STD_LOGIC;
		START					: in STD_LOGIC;
		donePredMov			: in STD_LOGIC;
		doneFirstSearch	: in STD_LOGIC;
		doneRaster			: in STD_LOGIC;
		vecBig				: in STD_LOGIC;
		STARTPredMov		: out STD_LOGIC;
		STARTFirstSearch	: out STD_LOGIC;
		STARTRaster			: out STD_LOGIC;
		loadSearchCenter	: out STD_LOGIC;
		sel_TZ_stage		: out STD_LOGIC_VECTOR(1 downto 0);
		done					: out STD_LOGIC
	);
end UC_TZSearch;

architecture Behavioral of UC_TZSearch is

type t_state is (idle, s_PredMov, s_FirstSearch, testVecBig, s_Raster, s_RefinementSearch, stateDone);
signal state, nextState: t_state;

begin

process(CLK, START)
begin
	if(START = '0') then
		state <= idle;
	elsif(CLK'event and CLK='1') then
		state <= nextState;
	end if;
end process;

process(state, donePredMov, doneFirstSearch, doneRaster, vecBig)
begin

	case state is
	
		when idle =>
			STARTPredMov <= '0';
			STARTFirstSearch <= '0';
			STARTRaster <= '0';
			sel_TZ_stage <= "00";
			done <= '0';
			loadSearchCenter <= '0';
			nextState <= s_PredMov;
		
		when s_PredMov =>
			STARTPredMov <= '1';
			loadSearchCenter <= '1';
			sel_TZ_stage <= "00";
			if(donePredMov = '1') then
				STARTPredMov <= '1';
				loadSearchCenter <= '0';
				sel_TZ_stage <= "00";
				nextState <= s_FirstSearch;
			else
				sel_TZ_stage <= "00";
			end if;
	
--		when s_FirstSearch =>
--			STARTFirstSearch <= '1';
--			STARTRaster <= '0';
--			sel_TZ_stage <= "01";
--			if(doneFirstSearch = '1') then
--				STARTFirstSearch <= '1';
--				STARTRaster <= '0';
--				sel_TZ_stage <= "01";
--				nextState <= s_Raster;
--			end if;

		when s_FirstSearch =>
			STARTFirstSearch <= '1';
			STARTRaster <= '0';
			sel_TZ_stage <= "01";
			if(doneFirstSearch = '1') then
				STARTFirstSearch <= '1';
				STARTRaster <= '0';
				sel_TZ_stage <= "01";
				nextState <= testVecBig;
			end if;
		
		when testVecBig =>
			STARTFirstSearch <= '0';
			if(vecBig = '1') then
				nextState <= s_Raster;
			else
				nextState <= s_RefinementSearch;
			end if;
				
		when s_Raster =>
			STARTFirstSearch <= '0';
			STARTRaster <= '1';
			sel_TZ_stage <= "10";
			if(doneRaster = '1') then
				STARTRaster <= '1';
				sel_TZ_stage <= "10";
				nextState <= s_RefinementSearch;
			end if;
		
		when s_RefinementSearch =>
			STARTFirstSearch <= '1';
			sel_TZ_stage <= "11";
			if(doneFirstSearch = '1') then
				STARTFirstSearch <= '1';
				nextState <= stateDone;
			end if;
			
		when stateDone =>
			done <= '1';
	
	end case;
end process;

end Behavioral;

