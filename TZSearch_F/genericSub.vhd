----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:25:38 10/01/2014 
-- Design Name: 
-- Module Name:    genericSub - Behavioral 
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
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity genericSub is
	Port(
			a: in std_logic_vector(7 downto 0);
			b: in std_logic_vector (7 downto 0);
			c: out std_logic_vector (7 downto 0)
	);
end genericSub;

architecture Behavioral of genericSub is

signal sig_C, not_sig_C: STD_LOGIC_VECTOR(8 downto 0);

begin

sig_C <= ('0' & a) - ('0' & b);
not_sig_C <= ('0' & b) - ('0' & a);

with sig_c(8) select
	c <= sig_c(7 downto 0) when '0',
	     not_sig_c(7 downto 0) when OTHERS;

end Behavioral;