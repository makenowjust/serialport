lib LibC
  # from fnctl.h
  O_NOCTTY = 0x20000

  # from termios.h
  CCTS_OFLOW = 0x00010000
  CRTS_IFLOW = 0x00020000
  CDTR_IFLOW = 0x00040000
  CDSR_OFLOW = 0x00080000
  CCAR_OFLOW = 0x00100000
  CRTSCTS    = (CCTS_OFLOW | CRTS_IFLOW)

  VTIME = 17

  fun cfsetospeed(termios_p : Termios*, speed : SpeedT) : Int
  fun cfsetispeed(termios_p : Termios*, speed : SpeedT) : Int

  fun tcdrain(fd : Int) : Int
end
