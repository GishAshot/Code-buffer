# Выход тактирования SPI (идет на ножки 20 SCLK обеих AD7708)
set_property PACKAGE_PIN <НОМЕР_НОЖКИ> [get_ports SPI_SCLK]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_SCLK]

# Выход данных от ПЛИС в АЦП (идет на ножки 24 DIN обеих AD7708)
set_property PACKAGE_PIN <НОМЕР_НОЖКИ> [get_ports SPI_MOSI]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_MOSI]

# Вход данных от АЦП в ПЛИС (идет от ножек 23 DOUT микросхем)
set_property PACKAGE_PIN <НОМЕР_НОЖКИ> [get_ports SPI_MISO]
set_property IOSTANDARD LVCMOS33 [get_ports SPI_MISO]
# Включаем внутреннюю подтяжку к 3.3В на случай, если чип перейдет в Hi-Z:
set_property PULLUP true [get_ports SPI_MISO]

# Выбор первого АЦП (идет на ножку 21 CS микросхемы 1)
set_property PACKAGE_PIN <НОМЕР_НОЖКИ> [get_ports {SPI_CS_N[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SPI_CS_N[0]}]

# Выбор второго АЦП (идет на ножку 21 CS микросхемы 2)
set_property PACKAGE_PIN <НОМЕР_НОЖКИ> [get_ports {SPI_CS_N[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SPI_CS_N[1]}]