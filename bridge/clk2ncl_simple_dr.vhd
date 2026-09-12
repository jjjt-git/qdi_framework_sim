library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;

entity clk2ncl_simple_dr is
	generic (
		dr_width: integer := 2
	);
	port (
		clk, rst: in std_logic;
		dro_0, dro_1: out std_logic_vector(dr_width - 1 downto 0);
		ki: in std_logic;
		valid: in std_logic;
		stall: out std_logic;
		dri: in std_logic_vector(dr_width - 1 downto 0)
	);
end clk2ncl_simple_dr;

architecture Behavioural of clk2ncl_simple_dr is
	signal d_r : std_logic_vector(dr_width - 1 downto 0);
	signal v_r : std_logic;

	signal ki_m, ki_s, ki_sn : std_logic;

	signal ki_edge : std_logic;
begin
	stall <= v_r;

	dro_0 <= do_0m;
	dro_1 <= do_1m;

	ki_edge <= not ki_s and ki_sn;

	in_regs: process(clk) begin
		if falling_edge(clk) then
			if rst = '1' then
				d_r <= (others => '0');
			elsif v_r = '0' and valid = '1' then
				d_r <= dri;
			end if;
		end if;

		if rising_edge(clk) then
			if rst = '1' then
				v_r <= '0';
			elsif v_r = '0' then
				v_r <= valid;
			elsif ki_edge = '1' then
				v_r <= '0';
			end if;
		end if;
	end process in_regs;

	ki_in: process(clk, rst) begin
		if rst = '1' then
			ki_m <= '0';
			ki_s <= '0';
			ki_sn <= '0';
		else
			if falling_edge(clk) then
				ki_m <= ki;
				ki_s <= ki_m;
			end if;

			if rising_edge(clk) then
				ki_sn <= ki_s;
			end if;
		end if;
	end process ki_in;

	dro_0 <= not d_r and v_r and ki_s;
	dro_1 <=     d_r and v_r and ki_s;

end Behavioural;
