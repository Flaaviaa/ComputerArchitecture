library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity EXECUTE_PACKAGE_TB is
end entity;


architecture A_EXECUTE_PACKAGE_TB of EXECUTE_PACKAGE_TB is
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal estado : unsigned(1 downto 0) := "00";
    signal exe_instrucao_jumpbi5 : std_logic := '0';
    signal exe_select_mux_pc : unsigned(1 downto 0) := "00";
    signal exe_instrucao_zera_flags : std_logic := '0';
    signal exe_select_op_ula : unsigned(1 downto 0) := "00";
    signal exe_ina_ula : unsigned(15 downto 0) := "0000000000000000";
    signal exe_inb_ula : unsigned(15 downto 0) := "0000000000000000";
    signal exe_bit5 : std_logic := '0';
    signal exe_result_ula : unsigned(15 downto 0) := "0000000000000000";
    signal exe_saida_mux_pc : std_logic := '0';
    signal exe_saida_mux_pc_ou_bit5 : std_logic := '0';

    signal contador : unsigned(5 downto 0) := "000000";
    signal revesrse_contador : unsigned(3 downto 0) := "1111";

    component EXECUTE_PACKAGE
        port(
            clk : in std_logic;
            rst : in std_logic;
            estado : in unsigned(1 downto 0);
            exe_instrucao_jumpbi5 : in std_logic;
            exe_select_mux_pc : in unsigned(1 downto 0);
            exe_instrucao_zera_flags : in std_logic;
            exe_select_op_ula : in unsigned(1 downto 0);
            exe_ina_ula : in unsigned(15 downto 0);
            exe_inb_ula : in unsigned(15 downto 0);
            exe_bit5 : in std_logic;
            exe_result_ula : out unsigned(15 downto 0);
            exe_saida_mux_pc : out std_logic;
            exe_saida_mux_pc_ou_bit5 : out std_logic
        );
        end component;
    type mem is array (0 to 15) of unsigned(15 downto 0);
        constant valores_teste : mem := (
            0 =>   "0000000000000000",  
            1 =>   "1011000000001100",  
            2 =>   "1011001000010111",  
            3 =>   "1001111000000000",  
            4 =>   "0011010000000000",  
            5 =>   "1001111000000000",  
            6 =>   "1110000000000000",  
            7 =>   "1110100000001100",  
            8 =>   "0000001000000000",  
            9 =>   "1100000000000011",  
            10 =>  "1100110000001100",  
            11 =>  "0101000000000001",  
            12 =>  "0111111000000000",  
            13 =>  "0000000000000000",
            others => (others => '0')
        );  
    begin 
        EXECUTE_PACKAGE_INSTANCE : EXECUTE_PACKAGE port map(
            clk => clk,
            rst => rst,
            estado => estado,
            exe_instrucao_jumpbi5 => exe_instrucao_jumpbi5,
            exe_select_mux_pc => exe_select_mux_pc,
            exe_instrucao_zera_flags => exe_instrucao_zera_flags,
            exe_select_op_ula => exe_select_op_ula,
            exe_ina_ula => exe_ina_ula,
            exe_inb_ula => exe_inb_ula,
            exe_bit5 => exe_bit5,
            exe_result_ula => exe_result_ula,
            exe_saida_mux_pc => exe_saida_mux_pc,
            exe_saida_mux_pc_ou_bit5 => exe_saida_mux_pc_ou_bit5
        );

        process
            begin 
                while contador /= "111111" loop
                    exe_ina_ula                 <= valores_teste(to_integer(contador(3 downto 0)));
                    exe_inb_ula                 <= valores_teste(to_integer(revesrse_contador));
                    exe_bit5                    <= contador(1);
                    exe_select_op_ula           <= contador(4 downto 3);
                    exe_instrucao_zera_flags    <= '1';
                    exe_select_mux_pc           <= contador(1 downto 0);
                    exe_instrucao_jumpbi5       <= contador(2);
                    wait for 50 ns;
                    contador <= contador + 1;
                    if revesrse_contador /= "0000" then
                        revesrse_contador <= revesrse_contador - 1;
                    else
                        revesrse_contador <= "1111";
                    end if;
                end loop;
                wait;
        end process;
end architecture;