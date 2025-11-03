library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sum10_pipeline is
    port (
        clk  : in  std_logic;
        in0  : in  std_logic_vector(7 downto 0);
        in1  : in  std_logic_vector(7 downto 0);
        in2  : in  std_logic_vector(7 downto 0);
        in3  : in  std_logic_vector(7 downto 0);
        in4  : in  std_logic_vector(7 downto 0);
        in5  : in  std_logic_vector(7 downto 0);
        in6  : in  std_logic_vector(7 downto 0);
        in7  : in  std_logic_vector(7 downto 0);
        in8  : in  std_logic_vector(7 downto 0);
        in9  : in  std_logic_vector(7 downto 0);
        result_out : out std_logic_vector(11 downto 0)
    );
end sum10_pipeline;

architecture rtl of sum10_pipeline is
    -- Level 1
    signal pair_sum_0, pair_sum_1, pair_sum_2, pair_sum_3, pair_sum_4 : std_logic_vector(8 downto 0);

    -- Level 2
    signal mid_sum_0, mid_sum_1, mid_sum_2 : std_logic_vector(9 downto 0);

    -- Level 3
    signal upper_sum_0, upper_sum_1 : std_logic_vector(10 downto 0);

    -- Level 4
    signal final_sum : std_logic_vector(11 downto 0);
begin

    -- Level 1
    process(all) begin
        if rising_edge(clk) then
            pair_sum_0 <= std_logic_vector(resize(signed(in0), 9) + resize(signed(in1), 9));
            pair_sum_1 <= std_logic_vector(resize(signed(in2), 9) + resize(signed(in3), 9));
            pair_sum_2 <= std_logic_vector(resize(signed(in4), 9) + resize(signed(in5), 9));
            pair_sum_3 <= std_logic_vector(resize(signed(in6), 9) + resize(signed(in7), 9));
            pair_sum_4 <= std_logic_vector(resize(signed(in8), 9) + resize(signed(in9), 9));
        end if;
    end process;

    -- Level 2
    process(all) begin
        if rising_edge(clk) then
            mid_sum_0 <= std_logic_vector(resize(signed(pair_sum_0), 10) + resize(signed(pair_sum_1), 10));
            mid_sum_1 <= std_logic_vector(resize(signed(pair_sum_2), 10) + resize(signed(pair_sum_3), 10));
            mid_sum_2 <= std_logic_vector(resize(signed(pair_sum_4), 10) + to_signed(0, 10));
        end if;
    end process;

    -- Level 3
    process(all) begin
        if rising_edge(clk) then
            upper_sum_0 <= std_logic_vector(resize(signed(mid_sum_0), 11) + resize(signed(mid_sum_1), 11));
            upper_sum_1 <= std_logic_vector(resize(signed(mid_sum_2), 11) + to_signed(0, 11));
        end if;
    end process;

    -- Level 4
    process(all) begin
        if rising_edge(clk) then
            final_sum <= std_logic_vector(resize(signed(upper_sum_0), 12) + resize(signed(upper_sum_1), 12));
        end if;
    end process;

    result_out <= final_sum;
end architecture;
