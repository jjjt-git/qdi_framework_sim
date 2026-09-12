library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fb_3 is
	generic (
		CLEAR_SET   : bit_vector(31 downto 0) := x"0000_0001";
		ASSERT_SET  : bit_vector(31 downto 0)
	);
	port (
		A, B, C : in std_logic;
		Z : out std_logic
	);
end fb_3;

architecture Structural of fb_3 is
	signal output : std_logic;
	signal addr   : std_logic_vector(4 downto 0);
begin
	addr <= (
		4 => '0',
		3 => '0',
		2 => C,
		1 => B,
		0 => A
	);

	gate: process(addr) begin
		if ASSERT_SET(to_integer(unsigned(addr))) = '1' then
			output <= '1';
		elsif CLEAR_SET(to_integer(unsigned(addr))) = '1' then
			output <= '0';
		end if;
	end process gate;

	Z <= transport output after 1 ns;

end Structural;
