
ller.fan", package.seeall)

function index()
    entry({"admin", "services", "fan"}, cbi("fan/fan_config"), _("Fan Control"), 20).dependent = true
    entry({"admin", "services", "fan", "status"}, call("action_status")).leaf = true
    entry({"admin", "services", "fan", "control"}, call("action_control")).leaf = true
end

local function read_temperature()
    local temperature = luci.sys.exec("cat /sys/class/thermal/thermal_zone0/temp")
    return tonumber(temperature) / 1000 -- Konversi ke derajat Celcius
end

local function set_fan_state(state)
    local gpio_path = "/sys/class/gpio/gpio507/value"
    if state == "on" then
        luci.sys.exec("echo 1 > " .. gpio_path)
    else
        luci.sys.exec("echo 0 > " .. gpio_path)
    end
end

function action_status()
    local gpio_value = luci.sys.exec("cat /sys/class/gpio/gpio507/value")
    local temperature = read_temperature()
    luci.http.prepare_content("application/json")
    luci.http.write_json({
        gpio_status = gpio_value,
        temperature = temperature
    })
end

function action_control()
    local action = luci.http.formvalue("action")
    local delay_time = 5 -- Waktu tunggu dalam detik
    local temp_threshold = 50 -- Ambang batas suhu (contoh: 50°C)

    if action == "on" then
        local temp_start = read_temperature()
        luci.sys.exec("sleep " .. delay_time)
        local temp_end = read_temperature()

        if temp_start >= temp_threshold and temp_end >= temp_threshold then
            set_fan_state("on")
            luci.http.prepare_content("application/json")
            luci.http.write_json({ status = "ON", message = "Fan turned ON after delay" })
        else
            luci.http.prepare_content("application/json")
            luci.http.write_json({ status = "OFF", message = "Temperature below threshold during delay" })
        end
    elseif action == "off" then
        set_fan_state("off")
        luci.http.prepare_content("application/json")
        luci.http.write_json({ status = "OFF", message = "Fan turned OFF" })
    else
        luci.http.status(400, "Bad Request")
    end
end
