library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- selectoption - seleciona a operação a ser feita, que são
-- 00 - soma
-- 01 - subtracao
-- 10 - overflow
-- 11 - carry 
        -- tanto carry como overflow fazem : a maior que b, a igual b


entity ULA is
    port (
        ina : in unsigned(15 downto 0) := "0000000000000000";
        inb : in unsigned(15 downto 0) := "0000000000000000";
        operacaozeraula :in std_logic := '0';
        operationselect : in unsigned(1 downto 0) := "00";
        overflow : out std_logic := '0';
        biggest : out std_logic := '0';
        equal : out std_logic := '0';
        result : out unsigned(15 downto 0) := "0000000000000000"
    );
end entity;

architecture a_ULA of ULA is
    signal sing_ina,sing_inb : unsigned(16 downto 0) := B"0000_0000_0000_0000_0";
    signal signal_overflow,signal_biggest,signal_equal : std_logic := '0';
    signal salvo_overflow,salvo_biggest,salvo_equal : std_logic := '0';
    signal sub : unsigned(16 downto 0) := "00000000000000000";
    signal soma : unsigned(16 downto 0) := "00000000000000000";

    begin
        sing_ina <= '0' & ina;

        sing_inb <= '0' & inb;

        soma <= sing_ina + sing_inb;

        sub <= sing_ina - sing_inb;

        result <=   soma(15 downto 0) when operationselect = "00" else
                    sub(15 downto 0) when operationselect = "01" else
                    "0000000000000000";

        signal_overflow <=  '1' when operationselect = "00" and ina(15) = '0' and inb(15) = '0' and soma(15) = '1' else -- caso a e b +
                            '1' when operationselect = "00" and ina(15) = '1' and inb(15) = '1' and soma(15) = '0' else-- caso a e b -
                            '1' when operationselect = "01" and ina(15) = '0' and inb(15) = '1' and sub(15) = '1' else
                            '1' when operationselect = "01" and ina(15) = '1' and inb(15) = '0' and sub(15) = '0' else
                            '0';
        
        signal_biggest <=   '0' when operationselect >= "10" and ina(15) = '1' and inb(15) = '0' else
                            '1' when operationselect >= "10" and ina(15) = '0' and inb(15) = '1' else
                            '1' when operationselect >= "10" and ina > inb else
                            '0';

        signal_equal <=     '1' when operationselect >= "10" and ina = inb else
                            '0';

        overflow <= signal_overflow ;
        biggest <= signal_biggest when operacaozeraula = '1' else '0'; --salvo_biggest;
        equal <= signal_equal when operacaozeraula = '1' else '0';--salvo_equal;

        -- overflow <= salvo_overflow;
        -- biggest <= salvo_biggest;
        -- equal <= salvo_equal;

    end architecture;
