library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CommandBuffer is
    generic(
        CMD_WIDTH : integer := 8;
        DEPTH     : integer := 32
    );
    port(
        clk   : in  std_logic;
        rst   : in  std_logic;

        s_axis_tvalid : in  std_logic;
        s_axis_tready : out std_logic;
        s_axis_tdata  : in  std_logic_vector(CMD_WIDTH-1 downto 0);

        m_axis_tvalid : out std_logic;
        m_axis_tready : in  std_logic;
        m_axis_tdata  : out std_logic_vector(CMD_WIDTH-1 downto 0)
    );
end CommandBuffer;

architecture rtl of CommandBuffer is

    type fifo_array is array (0 to DEPTH-1) of std_logic_vector(CMD_WIDTH-1 downto 0);

    signal fifo_a, fifo_b : fifo_array;

    signal wr_ptr_a, wr_ptr_b : integer range 0 to DEPTH := 0;
    signal rd_ptr_a, rd_ptr_b : integer range 0 to DEPTH := 0;

    signal active_buf : std_logic := '0';

    signal fifo_a_empty, fifo_b_empty : std_logic;
    signal fifo_a_full, fifo_b_full   : std_logic;

    signal in_ready  : std_logic;
    signal out_valid : std_logic;
    signal out_data  : std_logic_vector(CMD_WIDTH-1 downto 0);

begin

    fifo_a_empty <= '1' when rd_ptr_a = wr_ptr_a else '0';
    fifo_b_empty <= '1' when rd_ptr_b = wr_ptr_b else '0';

    fifo_a_full <= '1' when wr_ptr_a = DEPTH else '0';
    fifo_b_full <= '1' when wr_ptr_b = DEPTH else '0';

    in_ready <= '1' when
                ((active_buf = '0' and fifo_a_full = '0') or
                 (active_buf = '1' and fifo_b_full = '0'))
                else '0';

    s_axis_tready <= in_ready;

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                wr_ptr_a <= 0;
                wr_ptr_b <= 0;
            else
                if s_axis_tvalid = '1' and in_ready = '1' then
                    if active_buf = '0' then
                        fifo_a(wr_ptr_a) <= s_axis_tdata;
                        wr_ptr_a <= wr_ptr_a + 1;
                    else
                        fifo_b(wr_ptr_b) <= s_axis_tdata;
                        wr_ptr_b <= wr_ptr_b + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    process(active_buf, rd_ptr_a, rd_ptr_b, fifo_a, fifo_b, fifo_a_empty, fifo_b_empty)
    begin
        if active_buf = '0' then
            if fifo_a_empty = '0' then
                out_valid <= '1';
                out_data  <= fifo_a(rd_ptr_a);
            else
                out_valid <= '0';
                out_data  <= (others => '0');
            end if;
        else
            if fifo_b_empty = '0' then
                out_valid <= '1';
                out_data  <= fifo_b(rd_ptr_b);
            else
                out_valid <= '0';
                out_data  <= (others => '0');
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                rd_ptr_a <= 0;
                rd_ptr_b <= 0;
                active_buf <= '0';
            else
                if out_valid = '1' and m_axis_tready = '1' then
                    if active_buf = '0' then
                        rd_ptr_a <= rd_ptr_a + 1;
                        if rd_ptr_a + 1 = wr_ptr_a then
                            active_buf <= '1';
                            rd_ptr_a <= 0;
                            wr_ptr_a <= 0;
                        end if;
                    else
                        rd_ptr_b <= rd_ptr_b + 1;
                        if rd_ptr_b + 1 = wr_ptr_b then
                            active_buf <= '0';
                            rd_ptr_b <= 0;
                            wr_ptr_b <= 0;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    m_axis_tvalid <= out_valid;
    m_axis_tdata  <= out_data;

end rtl;
