
cal m, s

m = Map("fan", translate("Fan Control Settings"),
    translate("Configure the temperature thresholds and delay for the fan control system."))

s = m:section(TypedSection, "settings", translate("Settings"))
s.anonymous = true

s:option(Value, "temp_min", translate("Minimum Temperature (°C)"),
    translate("The minimum temperature to turn off the fan."))
s:option(Value, "temp_max", translate("Maximum Temperature (°C)"),
    translate("The maximum temperature to turn on the fan."))
s:option(Value, "delay_seconds", translate("Delay (seconds)"),
    translate("Delay time before the fan is activated after the maximum temperature is reached."))

return m
