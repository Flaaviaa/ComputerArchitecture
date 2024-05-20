library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity opcodedecoder_tb is
end entity;

architecture a_opcodedecoder_tb of opcodedecoder_tb is

    signal instrucao : unsigned(15 downto 0) := "0000000000000000";
    signal contador : unsigned(2 downto 0) := "000";
    signal registradordestino : unsigned(3 downto 0);
    signal registrador1 : unsigned(3 downto 0);
    signal registrador2 : unsigned(3 downto 0);
    signal constante : unsigned(4 downto 0);

    type mem is array (0 to 7) of unsigned(15 downto 0);
    constant valores_teste : mem := (
        0 => "1000111110001000",
        1 => "1001111010011001",
        2 => "1010110110101010",
        3 => "1011110010111011",
        4 => "1100101111001100",
        5 => "1101101011011101",
        6 => "1110100111101110",
        7 => "1111100011111111",
        others => (others => '0')
    );

    component opcodedecoder is
        port(
            instrucao : in unsigned(15 downto 0);
            soma : out std_logic;
            somaimediata : out std_logic;
            subtracao : out std_logic;
            subtracaoimediata : out std_logic;
            cargaconstante : out std_logic;
            bneconstante : out std_logic;
            bneregistradores : out std_logic;
            branchparaendereco : out std_logic;
            branchrelativo : out std_logic;

            registradordestino : out unsigned(3 downto 0);
            registrador1 : out unsigned(3 downto 0);
            registrador2 : out unsigned(3 downto 0);
            constante : out unsigned(4 downto 0)
        );
        end component;

    begin 
    uut : opcodedecoder port map(
        registradordestino => registradordestino,
        registrador1 => registrador1,
        registrador2 => registrador2,
        constante => constante,
        instrucao => instrucao
    );

    process
    begin 
        while contador /= "111" loop
            instrucao <= valores_teste(to_integer(contador));
            wait for 50 ns;
            contador <= contador + 1;

        end loop;
        wait;
    end process;
end architecture;
