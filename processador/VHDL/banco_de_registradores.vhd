library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_de_registradores is
    port (  reg_select_1      : in unsigned(2 downto 0) := "000";
            reg_select_2      : in unsigned(2 downto 0) := "000";     
            regWrite          : in unsigned(2 downto 0) := "000";
            entr             : in unsigned(15 downto 0) := "0000000000000000";
            wr_en             : in std_logic := '1';
            clk               : in std_logic := '1';
            rst               : in std_logic := '1';
            reg_data1         : out unsigned(15 downto 0) := "0000000000000000";  
            reg_data2         : out unsigned(15 downto 0) := "0000000000000000" 
    );
end entity;

architecture a_banco_de_registradores of banco_de_registradores is
    component reg16bits is
        port( clk      : in std_logic;
              rst      : in std_logic;
              wr_en    : in std_logic;
              data_in  : in unsigned(15 downto 0);
              data_out : out unsigned(15 downto 0)
        );
    end component;

    signal data_in: unsigned(15 downto 0) := "0000000000000000";
    signal wr_en1, wr_en2, wr_en3, wr_en4, 
           wr_en5, wr_en6, wr_en7: std_logic := '0';    

    signal data_out0, data_out1, data_out2, data_out3, data_out4, 
           data_out5, data_out6, data_out7: unsigned(15 downto 0) := "0000000000000000";  
	
   begin
		reg0: reg16bits port map(clk => clk, rst => '1', wr_en => '0', data_in => data_in, data_out => data_out0);
		reg1: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en1, data_in => data_in, data_out=> data_out1);
		reg2: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en2, data_in => data_in, data_out=> data_out2);
		reg3: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en3, data_in => data_in, data_out=> data_out3);
		reg4: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en4, data_in => data_in, data_out=> data_out4);
		reg5: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en5, data_in => data_in, data_out=> data_out5);
		reg6: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en6, data_in => data_in, data_out=> data_out6);
		reg7: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en7, data_in => data_in, data_out=> data_out7);
		
        data_in <= entr;

        wr_en1 <= '1' when wr_en='1' and regWrite="001" else '0';
        wr_en2 <= '1' when wr_en='1' and regWrite="010" else '0';
        wr_en3 <= '1' when wr_en='1' and regWrite="011" else '0';
        wr_en4 <= '1' when wr_en='1' and regWrite="100" else '0';
        wr_en5 <= '1' when wr_en='1' and regWrite="101" else '0';
        wr_en6 <= '1' when wr_en='1' and regWrite="110" else '0';
        wr_en7 <= '1' when wr_en='1' and regWrite="111" else '0';

        reg_data1 <= data_out0 when reg_select_1="000" else
                     data_out1 when reg_select_1="001" else
                     data_out2 when reg_select_1="010" else
                     data_out3 when reg_select_1="011" else
                     data_out4 when reg_select_1="100" else
                     data_out5 when reg_select_1="101" else
                     data_out6 when reg_select_1="110" else
                     data_out7 when reg_select_1="111" else
                     "0000000000000000";
    
        reg_data2 <= data_out0 when reg_select_2="000" else
                     data_out1 when reg_select_2="001" else
                     data_out2 when reg_select_2="010" else
                     data_out3 when reg_select_2="011" else
                     data_out4 when reg_select_2="100" else
                     data_out5 when reg_select_2="101" else
                     data_out6 when reg_select_2="110" else
                     data_out7 when reg_select_2="111" else
                     "0000000000000000";


	end a_banco_de_registradores;
	