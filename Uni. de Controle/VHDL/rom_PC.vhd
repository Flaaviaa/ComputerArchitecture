library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- component rom
--             port(
--                 clk         : in std_logic ;
--                 endereco    : in unsigned(6 downto 0);
--                 dado        : out unsigned(15 downto 0)
--             );
--         end component;

--         component somaum
--             port(
--                 clk     : in std_logic;
--                 entrada : in unsigned(15 downto 0);
--                 saida   : out unsigned(15 downto 0)
--             );
--         end component;

--         component PC
--             port(
--                 clk      : in std_logic;
--                 wr_en    : in std_logic;
--                 data_in  : in unsigned(15 downto 0);
--                 data_out : out unsigned(15 downto 0)
--             );
--         end component;

entity rom_PC is
    port(
        clk : in std_logic;

        rom_endereco : in unsigned(6 downto 0);
        rom_dado : out unsigned(15 downto 0);

        somaum_entrada : in unsigned(6 downto 0);
        somaum_saida : out unsigned(6 downto 0);

        pc_wr_en : in std_logic;
        pc_data_in : in unsigned(6 downto 0);
        pc_data_out : out unsigned(6 downto 0)
    );
end entity;

architecture a_rom_PC of rom_PC is
    component PC is 
        port(
            clk      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0)
        );
    end component;

    component somaum is
        port(
            entrada : in unsigned(6 downto 0);
            saida   : out unsigned(6 downto 0)
        );
    end component;

    component rom is
        port(
            clk         : in std_logic;
            endereco    : in unsigned(6 downto 0);
            dado        : out unsigned(15 downto 0)
        );
    end component;


    begin
        PC_instance : PC port map(
            clk => clk,
            wr_en => pc_wr_en,
            data_in => pc_data_in,
            data_out => pc_data_out
        );

        somaum_instance : somaum port map(
            entrada => somaum_entrada,
            saida => somaum_saida
        );

        rom_instance : rom port map(
            clk => clk,
            endereco => rom_
        );

end architecture;


                    
