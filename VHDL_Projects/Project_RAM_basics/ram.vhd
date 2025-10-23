library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
  generic (
    DATA_BITS : integer := 8;
    ADDR_BITS : integer := 7;
    DEPTH     : integer := 100
  );
  port (
    clk     : in  std_logic;
    rst     : in  std_logic;
    wr_en   : in  std_logic;
    wr_addr : in  std_logic_vector(ADDR_BITS-1 downto 0);
    wr_data : in  std_logic_vector(DATA_BITS-1 downto 0);
    rd_en   : in  std_logic;
    rd_addr : in  std_logic_vector(ADDR_BITS-1 downto 0);
    rd_data : out std_logic_vector(DATA_BITS-1 downto 0)
  );
end ram;

architecture rtl of ram is
  type mem_t is array (0 to DEPTH-1) of std_logic_vector(DATA_BITS-1 downto 0);
  signal mem : mem_t := (others => (others => '0'));
  signal q    : std_logic_vector(DATA_BITS-1 downto 0);
begin
  process(clk)
    variable wa, ra : integer;
  begin
    if rising_edge(clk) then
      if wr_en = '1' then
        wa := to_integer(unsigned(wr_addr));
        if wa < DEPTH then
          mem(wa) <= wr_data;
        end if;
      end if;
      if rd_en = '1' then
        ra := to_integer(unsigned(rd_addr));
        if ra < DEPTH then
          q <= mem(ra);
        else
          q <= (others => '0');
        end if;
      end if;
      if rst = '1' then
        q <= (others => '0');
      end if;
    end if;
  end process;
  rd_data <= q;
end rtl;
