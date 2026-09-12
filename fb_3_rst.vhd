library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fb_3_rst is
	generic (
		RST_VALUE   : bit;
		CLEAR_SET   : bit_vector(31 downto 0) := x"0000_0001";
		ASSERT_SET  : bit_vector(31 downto 0)
	);
	port (
		A, B, C, R : in std_logic;
		Z : out std_logic
	);
end fb_3_rst;

architecture Structural of fb_3_rst is
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

	gate: process(R, addr) begin
		if R = '1' then
			if RST_VALUE = '1' then
				output <= '1';
			else
				output <= '0';
			end if;
		elsif ASSERT_SET(to_integer(unsigned(addr))) = '1' then
			output <= '1';
		elsif CLEAR_SET(to_integer(unsigned(addr))) = '1' then
			output <= '0';
		end if;
	end process gate;

	Z <= transport output after 1 ns;

end Structural;
