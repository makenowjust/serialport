# serialport

[serial port](https://en.wikipedia.org/wiki/Serial_port) library for Crystal

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  serial-port:
    github: MakeNowJust/serialport
```

## Usage

```crystal
require "serialport"

# Create a serial port connection.
serial = SerialPort.new "/dev/your-serialport", Termios::BaudRate::B9600

# `SerialPort` inherits from `IO`,
# so you can write text to the serial port with `<<` method.
serial << "Hello world!"

# And, you can read from the serial port with `gets` method.
loop do
  puts serial.gets
  sleep 0.1
end
```

## TODO

  - [ ] Write specs
  - [ ] Make more configurable (currently, baudrate only)
  - [ ] Support more platforms

## Contributing

  1. Fork it (<https://github.com/MakeNowJust/serialport/fork>)
  2. Create your feature branch (`git checkout -b my-new-feature`)
  3. Commit your changes (`git commit -am 'Add some feature'`)
  4. Push to the branch (`git push origin my-new-feature`)
  5. Create a new Pull Request

## Contributor

  - [MakeNowJust](https://github.com/MakeNowJust) TSUYUSATO Kitsune - creator, maintainer

## License and Copyright

MIT and [🍣](https://github.com/MakeNowJust/sushi-ware)
© TSUYUSATO "[MakeNowJust](https://quine.codes)" Kitsune <<make.just.on@gmail.com>> 2016
