library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ctrl is
  port (
    clk          : in  std_logic;
    rst          : in  std_logic;
    start        : in  std_logic;
    data_in      : in  std_logic_vector(7 downto 0);
    data_out     : out std_logic_vector(7 downto 0);
    out_valid    : out std_logic;
    in_ready     : out std_logic;
    ram_wr_en    : out std_logic;
    ram_wr_addr  : out std_logic_vector(6 downto 0);
    ram_wr_data  : out std_logic_vector(7 downto 0);
    ram_rd_en    : out std_logic;
    ram_rd_addr  : out std_logic_vector(6 downto 0);
    ram_rd_data  : in  std_logic_vector(7 downto 0);
    done         : out std_logic
  );
end ctrl;

architecture rtl of ctrl is
  type state_t is (idle, write_start, writing, write_done, read_start, reading, read_done, finish);
  signal s, s_next : state_t;
  signal addr, addr_next : unsigned(6 downto 0) := (others => '0');
  signal cycle, cycle_next : unsigned(0 downto 0) := "0";
  constant LAST : unsigned(6 downto 0) := to_unsigned(99,7);
begin
  process(s, addr, cycle, start, ram_rd_data)
  begin
    s_next <= s;
    addr_next <= addr;
    cycle_next <= cycle;
    ram_wr_en <= '0';
    ram_rd_en <= '0';
    in_ready <= '0';
    out_valid <= '0';
    ram_wr_data <= data_in;
    ram_wr_addr <= std_logic_vector(addr);
    ram_rd_addr <= std_logic_vector(addr);
    data_out <= (others => '0');
    done <= '0';
    case s is
      when idle =>
        if start = '1' then s_next <= write_start; end if;
        addr_next <= (others => '0');
      when write_start =>
        addr_next <= (others => '0');
        s_next <= writing;
      when writing =>
        ram_wr_en <= '1';
        in_ready <= '1';
        if addr = LAST then s_next <= write_done; else addr_next <= addr + 1; end if;
      when write_done =>
        addr_next <= (others => '0');
        s_next <= read_start;
      when read_start =>
        addr_next <= (others => '0');
        s_next <= reading;
      when reading =>
        ram_rd_en <= '1';
        out_valid <= '1';
        data_out <= ram_rd_data;
        if addr = LAST then s_next <= read_done; else addr_next <= addr + 1; end if;
      when read_done =>
        if cycle = "0" then
          cycle_next <= "1";
          s_next <= write_start;
        else
          s_next <= finish;
        end if;
      when finish =>
        done <= '1';
      when others =>
        s_next <= idle;
    end case;
  end process;

  process(clk, rst)
  begin
    if rst = '1' then
      s <= idle;
      addr <= (others => '0');
      cycle <= "0";
    elsif rising_edge(clk) then
      s <= s_next;
      addr <= addr_next;
      cycle <= cycle_next;
    end if;
  end process;
end rtl;
