require "./serialport/*"

class SerialPort < IO::FileDescriptor
  getter path

  def initialize(@path : String, baudrate : Termios::BaudRate, blocking = false)
    oflag = LibC::O_RDWR | LibC::O_NOCTTY | LibC::O_SYNC | LibC::O_CLOEXEC

    fd = LibC.open(path.check_no_null_byte, oflag)
    if fd < 0
      raise Errno.new("Error opening serial port '#{path}'")
    end

    self.sync = true # no buffering

    set_interface_attributes(fd, baudrate, blocking)
    super fd, blocking
  end

  private def set_interface_attributes(fd, baudrate, blocking)
    if LibC.tcgetattr(fd, out mode) != 0
      raise Error.new("initialize serial port: tcgetaddr")
    end

    LibC.cfsetospeed(pointerof(mode), baudrate)
    LibC.cfsetispeed(pointerof(mode), baudrate)

    mode.c_cflag |= (Termios::ControlMode::CLOCAL |
                     Termios::ControlMode::CREAD).value # ignore modem controls
    mode.c_cflag &= ~Termios::ControlMode::CSIZE.value
    mode.c_cflag |= Termios::ControlMode::CS8.value     # 8-bit characters
    mode.c_cflag &= ~Termios::ControlMode::PARENB.value # no parity bit
    mode.c_cflag &= ~Termios::ControlMode::CSTOPB.value # only need 1 stop bit
    mode.c_cflag &= ~LibC::CRTSCTS                      # no hardware flowcontrol

    mode.c_iflag &= ~(Termios::InputMode::IGNBRK |
                      Termios::InputMode::BRKINT |
                      Termios::InputMode::PARMRK |
                      Termios::InputMode::ISTRIP |
                      Termios::InputMode::INLCR |
                      Termios::InputMode::IGNCR |
                      Termios::InputMode::ICRNL |
                      Termios::InputMode::IXON).value
    mode.c_lflag &= ~(Termios::LocalMode::ECHO |
                      Termios::LocalMode::ECHONL |
                      Termios::LocalMode::ICANON |
                      Termios::LocalMode::ISIG |
                      Termios::LocalMode::IEXTEN).value
    mode.c_oflag &= ~Termios::OutputMode::OPOST.value

    mode.c_cc[LibC::VMIN] = blocking ? 1_u8 : 0_u8
    mode.c_cc[LibC::VTIME] = 5_u8

    if LibC.tcsetattr(fd, Termios::LineControl::TCSANOW, pointerof(mode)) != 0
      raise Error.new("initialize serial port: tcsetattr")
    end
  end
end
