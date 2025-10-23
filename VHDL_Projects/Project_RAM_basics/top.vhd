library ieee;
use ieee.std_logic_1164.all;

entity top is
  port (
    clk        : in  std_logic;
    rst        : in  std_logic;
    start      : in  std_logic;
    data_in    : in  std_logic_vector(7 downto 0);
    data_out   : out std_logic_vector(7 downto 0);
    out_valid  : out std_logic;
    in_ready   : out std_logic;
    done       : out std_logic
  );
end top;

architecture structural of top is
  signal wr_en, rd_en : std_logic;
  signal wr_addr, rd_addr : std_logic_vector(6 downto 0);
  signal wr_data, rd_data : std_logic_vector(7 downto 0);
begin
  u_ram : entity work.ram
    port map (
      clk => clk,
      rst => rst,
      wr_en => wr_en,
      wr_addr => wr_addr,
      wr_data => wr_data,
      rd_en => rd_en,
      rd_addr => rd_addr,
      rd_data => rd_data
    );

  u_ctrl : entity work.ctrl
    port map (
      clk => clk,
      rst => rst,
      start => start,
      data_in => data_in,
      data_out => data_out,
      out_valid => out_valid,
      in_ready => in_ready,
      ram_wr_en => wr_en,
      ram_wr_addr => wr_addr,
      ram_wr_data => wr_data,
      ram_rd_en => rd_en,
      ram_rd_addr => rd_addr,
      ram_rd_data => rd_data,
      done => done
    );
end structural;
