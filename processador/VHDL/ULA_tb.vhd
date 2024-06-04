library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity ULA_tb is
end entity;

architecture a_ULA_tb of ULA_tb is 
    signal ina,inb :unsigned(15 downto 0) := B"0000_0000_0000_0000";
    signal operationselect :unsigned(1 downto 0) := "00";
    signal overflow,biggest,equal,operacaozeraula :std_logic := '0';
    signal result :unsigned(15 downto 0) := B"0000_0000_0000_0000";

    signal contador : unsigned(4 downto 0) := "00000";

    component ULA is
        port (
            ina : in unsigned(15 downto 0);
            inb : in unsigned(15 downto 0);
            operacaozeraula :in std_logic := '0';
            operationselect : in unsigned(1 downto 0);
            overflow : out std_logic;
            biggest : out std_logic;
            equal : out std_logic;
            result : out unsigned(15 downto 0)
        );
        end component;

    begin 

        uut : ULA port map(
            ina => ina,
            inb => inb,
            operacaozeraula => operacaozeraula,
            operationselect => operationselect,
            overflow => overflow,
            biggest => biggest,
            equal => equal,
            result => result
        );

        process
            begin 
                while contador /= "11111" loop
                    wait for 50 ns;
                    contador <= contador + 1;
                    ina <= "00000000000" & contador(4 downto 0);
                    inb <= contador(2) & "0000000000" & contador(4 downto 0);
                    operationselect <= contador(1 downto 0);
                    operacaozeraula <= contador(3);
                end loop;
                wait;
        end process;

end architecture;