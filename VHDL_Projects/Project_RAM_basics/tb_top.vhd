library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_top is
end tb_top;

architecture sim of tb_top is
  signal clk : std_logic := '0';
  signal rst : std_logic := '1';
  signal start : std_logic := '0';
  signal data_in : std_logic_vector(7 downto 0) := (others => '0');
  signal data_out : std_logic_vector(7 downto 0);
  signal out_valid, in_ready, done : std_logic;
  signal counter : unsigned(7 downto 0) := (others => '0');
  constant PERIOD : time := 10 ns;
begin
  clk <= not clk after PERIOD/2;

  uut : entity work.top
    port map (
      clk => clk,
      rst => rst,
      start => start,
      data_in => data_in,
      data_out => data_out,
      out_valid => out_valid,
      in_ready => in_ready,
      done => done
    );

  process
  begin
    rst <= '1';
    wait for 5*PERIOD;
    rst <= '0';
    wait for 3*PERIOD;
    start <= '1';
    wait for PERIOD;
    start <= '0';
    wait until done = '1';
    wait for 10*PERIOD;
    assert false report "Simulation finished" severity failure;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if in_ready = '1' then
        data_in <= std_logic_vector(counter);
        counter <= counter + 1;
      end if;
      if out_valid = '1' then
        report "Read byte = " & integer'image(to_integer(unsigned(data_out)));
      end if;
    end if;
  end process;
end sim;
