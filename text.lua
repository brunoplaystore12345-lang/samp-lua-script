local imgui = require('mimgui')
local faicons = require('fAwesome6')
local widgets = require("widgets")
local vector3d = require("vector3d")
local ffi = require("ffi")
local json = require 'json'
local events = require "lib.samp.events"
local sampev = require "lib.samp.events"
local qdl = imgui.new.bool(false)
local activeTab = 1
local encoding = require('encoding')
encoding.default = ('CP1251')
u8 = encoding.UTF8
local SAMemory = require "SAMemory"
local DPI = MONET_DPI_SCALE

local gta = ffi.load("GTASA")
local camera = SAMemory.camera
local screenWidth, screenHeight = getScreenResolution()
SAMemory.require("CCamera")
ffi.cdef [[ typedef struct RwV3d{float x,y,z;}RwV3d;void _ZN4CPed15GetBonePositionER5RwV3djb(void* thiz,RwV3d* posn,uint32_t bone,bool calledFromCam);]]

local enable = imgui.new.bool(false)
local circuloFOVAIM = imgui.new.bool(false)
local VERIFICAskin = imgui.new.bool(true)
local matarbackwallsAIM  = imgui.new.bool(false)
local fovSizeAIM = imgui.new.float(130.0)
local distanceAIM = imgui.new.float(90.0)
local smoothvalue = imgui.new.float(7.0)
local SmoothTap = imgui.new.float(7.0)
local posiX = imgui.new.float(0.51899999380112)
local posiY = imgui.new.float(0.45800000429153)
local stickcamerawithoutmode = imgui.new.bool(false)

local enableSilent = imgui.new.bool(false)
local cabecaSilent = imgui.new.bool(true)
local melmaiak = imgui.new.bool(false) 
local matarbackwallsSilent = imgui.new.bool(false)
local offsetsilentcirculoX = imgui.new.float(0.2704)
local offsetsilentcirculoY = imgui.new.float(0.2015)
local tamanhoFOVsilent = imgui.new.float(130.0)
local circuloFOVsilent = imgui.new.bool(false)
local verificarSKIN = imgui.new.bool(true)
local minFov = 1
local sanguesilent = imgui.new.bool(false)
local fovColor = imgui.new.float[4](0.80, 0.00, 0.00, 0)
local bosrdabbsilen = imgui.new.float[4](0.80, 0.00, 0.00, 1.00)
local distanceAIMSILENT = imgui.new.float(90.0)
local hggostoso = false
local circuloFOV = false

local unloadBypass = imgui.new.bool(false)

local aimbotpjl = {
    cabecaAIM = imgui.new.bool(false),
    virilhaaimboott = imgui.new.bool(false),
    peitoaimboott = imgui.new.bool(false)
}

local font = renderCreateFont("Arial", 12, 1 + 4) local bones = { 3, 4, 5, 51, 52, 41, 42, 31, 32, 33, 21, 22, 23, 2 }

EspSulista = { enabled = imgui.new.bool(true), max_distance = imgui.new.int(250),

show_name = imgui.new.bool(false),
show_health_armor = imgui.new.bool(false),
show_line_and_distance = imgui.new.bool(false),
show_skeleton = imgui.new.bool(false),
show_distance = imgui.new.bool(false),
show_box = imgui.new.bool(false),
show_weapon = imgui.new.bool(false),
show_status = imgui.new.bool(false),
localPLAYER = imgui.new.bool(false),
ignorarDENTROveiculo = imgui.new.bool(false),

font = font

}

local pjl = {
    bordaaimon = imgui.new.float[4](1.00, 1.00, 1.00, 1.00),
    minFov = 1,
    fovColorAim = imgui.new.float[4](0.80, 0.00, 0.00, 0.00),
}

local flags = imgui.WindowFlags.NoTitleBar
+ imgui.WindowFlags.NoCollapse
+ imgui.WindowFlags.NoResize
+ imgui.WindowFlags.NoScrollbar
+ imgui.WindowFlags.NoScrollWithMouse

    local function CustomTab(icon, label, id, offsetY, selected, size, rounding)
    local draw_list = imgui.GetWindowDrawList()
    local pos = imgui.GetCursorScreenPos()

    pos.y = pos.y + offsetY * DPI

    local tab_size = size or imgui.ImVec2(140 * DPI, 40 * DPI)

if type(tab_size) ~= "table" then
    tab_size = imgui.ImVec2(140 * DPI, 40 * DPI)
end

    local color_selected = imgui.GetColorU32Vec4(imgui.ImVec4(0.15, 0.47, 0.68, 1.0)) 
    local color_unselected = imgui.GetColorU32Vec4(imgui.ImVec4(0.12, 0.12, 0.12, 1.0))
    local text_selected = imgui.ImVec4(1.0, 1.0, 1.0, 1.0)
    local text_unselected = imgui.ImVec4(1.0, 1.0, 1.0, 0.7)

    draw_list:AddRectFilled(
        pos,
        imgui.ImVec2(pos.x + tab_size.x, pos.y + tab_size.y),
        selected and color_selected or color_unselected,
        rounding or 8 * DPI
    )

    imgui.SetCursorScreenPos(imgui.ImVec2(pos.x + 8 * DPI, pos.y + 11 * DPI))
    imgui.TextColored(selected and text_selected or text_unselected, faicons(icon))

    imgui.SameLine()
    imgui.TextColored(selected and text_selected or text_unselected, label)

    if imgui.IsMouseHoveringRect(pos, imgui.ImVec2(pos.x + tab_size.x, pos.y + tab_size.y))
       and imgui.IsMouseClicked(0) then
        activeTab = id
    end

    imgui.SetCursorPos(imgui.ImVec2((15) * DPI, offsetY * DPI))
end

function imgui.CustomCheckbox(str_id, bool, a_speed)
    local size = imgui.ImVec2(21 * DPI, 21 * DPI)
    local p = imgui.GetCursorScreenPos()
    local DL = imgui.GetWindowDrawList()
    local label = str_id:gsub("##.+", "") or ""
    local speed = a_speed or 0.3

    imgui.BeginGroup()
    imgui.InvisibleButton(str_id, size)
    imgui.SameLine()
    local pp = imgui.GetCursorPos()
    imgui.SetCursorPos(imgui.ImVec2(pp.x, pp.y + size.y / 7 - imgui.CalcTextSize(label).y / 7))
    imgui.Text(label)
    imgui.EndGroup()

    local clicked = imgui.IsItemClicked()
    local center = imgui.ImVec2(p.x + size.x / 2, p.y + size.y / 2)
    local radius = size.x / 2
    local segments = 32 * DPI
    local borderThickness = 2.0 * DPI

    local borderColor = imgui.ImVec4(90/255, 95/255, 102/255, 1.0) 
    local fillInactive = imgui.ImVec4(44/255, 78/255, 114/255, 1.0)     
    local fillActive = imgui.ImVec4(185/255, 214/255, 228/255, 1.0) 

    DL:AddCircle(center, radius, imgui.GetColorU32Vec4(borderColor), segments, borderThickness)
    
    local innerRadius = radius * 0.87
    local fillColor = bool[0] and fillActive or fillInactive
    DL:AddCircleFilled(center, innerRadius, imgui.GetColorU32Vec4(fillColor))

    if clicked then
        bool[0] = not bool[0]
    end

    return clicked
end

function CustomButton(label, size)
    local drawList = imgui.GetWindowDrawList()
    local cursorPos = imgui.GetCursorPos()
    local winPos = imgui.GetWindowPos()
    local buttonPos = imgui.ImVec2(winPos.x + cursorPos.x, winPos.y + cursorPos.y)

    local io = imgui.GetIO()
    local mousePos = io.MousePos
    local hovered = mousePos.x >= buttonPos.x and mousePos.x <= buttonPos.x + size.x and
                    mousePos.y >= buttonPos.y and mousePos.y <= buttonPos.y + size.y
    local pressed = hovered and imgui.IsMouseDown(0)

    local buttonColor = pressed
        and imgui.ImVec4(0.8, 0.8, 0.8, 1.0)
        or imgui.ImVec4(0.0, 0.0, 0.0, 1.0)

    local textColor = pressed
        and imgui.ImVec4(1, 1, 1, 1)
        or imgui.ImVec4(1, 1, 1, 1)

    drawList:AddRectFilled(
        buttonPos,
        imgui.ImVec2(buttonPos.x + size.x, buttonPos.y + size.y),
        imgui.ColorConvertFloat4ToU32(buttonColor),
        6 * DPI
    )

    local textSize = imgui.CalcTextSize(label)
    local textX = buttonPos.x + (size.x - textSize.x) * 0.5
    local textY = buttonPos.y + (size.y - textSize.y) * 0.5

    drawList:AddText(
        imgui.ImVec2(textX, textY),
        imgui.ColorConvertFloat4ToU32(textColor),
        label
    )

    return hovered and imgui.IsMouseClicked(0)
end

local slider_state = {}

function customSliderFloat(id, value, min, max, format)

    if type(value) ~= "cdata" or value[0] == nil or type(min) ~= "number" or type(max) ~= "number" then
        print("[ERRO] customSliderFloat recebeu argumentos inválidos")
        return
    end

    local draw_list = imgui.GetWindowDrawList()
    local io = imgui.GetIO()
    local cursor_pos = imgui.GetCursorScreenPos()

    local slider_width = 240 * DPI
    local slider_height = 32 * DPI
    local slider_size = imgui.ImVec2(slider_width, slider_height)
    local slider_pos = cursor_pos
    local slider_end = imgui.ImVec2(slider_pos.x + slider_size.x, slider_pos.y + slider_size.y)

    local handle_width = 10 * DPI
    local handle_height = slider_height

    local bg_color = imgui.ImVec4(0.15, 0.20, 0.30, 1.0)
    local text_color = imgui.ImVec4(1.0, 1.0, 1.0, 1.0)
    local fill_color = imgui.ImVec4(0.60, 0.85, 1.00, 0.85)
    local handle_border = imgui.ImVec4(0.8, 0.9, 1.0, 0.5)

    local function lighten_color(color, percent)
        return imgui.ImVec4(
            math.min(color.x + (1 - color.x) * percent, 1.0),
            math.min(color.y + (1 - color.y) * percent, 1.0),
            math.min(color.z + (1 - color.z) * percent, 1.0),
            color.w
        )
    end

    imgui.SetCursorScreenPos(slider_pos)
    imgui.InvisibleButton("##custom_slider_" .. id, slider_size)
    local is_active = imgui.IsItemActive()

    local current_bg_color = is_active and lighten_color(bg_color, 0.3) or bg_color

    if not slider_state[id] then
        slider_state[id] = {
            start_fraction = (value[0] - min) / (max - min),
            start_mouse_x = 0
        }
    end

    if imgui.IsItemActivated() then
        slider_state[id].start_fraction = (value[0] - min) / (max - min)
        slider_state[id].start_mouse_x = io.MousePos.x
    end

    if is_active and imgui.IsMouseDragging(0) then
        local delta_x = io.MousePos.x - slider_state[id].start_mouse_x
        local delta_fraction = delta_x / (slider_size.x - handle_width)
        local new_fraction = slider_state[id].start_fraction + delta_fraction
        new_fraction = math.max(0.0, math.min(1.0, new_fraction))
        value[0] = min + (max - min) * new_fraction
    end

    local fraction = (value[0] - min) / (max - min)
    local handle_x = slider_pos.x + fraction * (slider_size.x - handle_width)

    draw_list:AddRectFilled(slider_pos, slider_end, imgui.GetColorU32Vec4(current_bg_color), 3)

    local handle_min = imgui.ImVec2(handle_x, slider_pos.y)
    local handle_max = imgui.ImVec2(handle_x + handle_width, slider_pos.y + handle_height)
    draw_list:AddRectFilled(handle_min, handle_max, imgui.GetColorU32Vec4(fill_color), 2)
    draw_list:AddRect(handle_min, handle_max, imgui.GetColorU32Vec4(handle_border), 2, 0, 1.0 * DPI)

    local value_text = string.format(format, value[0])
    local value_size = imgui.CalcTextSize(value_text)
    if font111 then imgui.PushFont(font111) end
    draw_list:AddText(
        imgui.ImVec2(slider_pos.x + (slider_size.x - value_size.x) / 2,
                     slider_pos.y + (slider_size.y - value_size.y) / 2),
        imgui.GetColorU32Vec4(text_color),
        value_text
    )
    if font111 then imgui.PopFont() end

    imgui.SetCursorScreenPos(imgui.ImVec2(cursor_pos.x, cursor_pos.y + slider_size.y + 10 * DPI))
end

local animationStates = {}

function imgui.ToggleButton(label, size, bool)
    local function ImSaturate(f)
        return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
    end
    
    if type(bool) ~= "cdata" and type(bool) ~= "table" or bool[0] == nil then
        return false
    end
    
    local p = imgui.GetCursorScreenPos()
    local dl = imgui.GetWindowDrawList()
    local r = size.y / 2
    local x_begin = bool[0] and 1.0 or 0.0
    local t_begin = bool[0] and 0.0 or 1.0
    local s = 0.4
    local anim = false

    if not animationStates[label] then
        animationStates[label] = {LastTime = nil, LastActive = false}
    end
    local state = animationStates[label]

    if imgui.InvisibleButton(label, size) then
        bool[0] = not bool[0]
        state.LastTime = os.clock()
        state.LastActive = true
        anim = true
    end

    if state.LastActive then
        local time = os.clock() - state.LastTime
        if time <= s then
            local anim_progress = ImSaturate(time / s)
            x_begin = bool[0] and anim_progress or 1.0 - anim_progress
            t_begin = bool[0] and 1.0 - anim_progress or anim_progress
        else
            state.LastActive = false
        end
    end

local bgColor = bool[0]
    and imgui.ImVec4(0.400, 0.702, 0.800, 1.0)
    or  imgui.ImVec4(0.302, 0.498, 0.560, 1.0)

local handleColor = imgui.ImVec4(0.729, 0.886, 0.922, 1.0)
local borderColor = imgui.ImVec4(0.345, 0.490, 0.533, 1.0)

    dl:AddRectFilled(
        imgui.ImVec2(p.x, p.y),
        imgui.ImVec2(p.x + size.x, p.y + size.y),
        imgui.GetColorU32Vec4(bgColor),
        r
    )

    dl:AddRect(
        imgui.ImVec2(p.x, p.y),
        imgui.ImVec2(p.x + size.x, p.y + size.y),
        imgui.GetColorU32Vec4(borderColor),
        r
    )

    local circleRadius = r * 1.05
    local circleSegments = 90
    dl:AddCircleFilled(
        imgui.ImVec2(p.x + r + x_begin * (size.x - r * 2), p.y + r),
        circleRadius,
        imgui.GetColorU32Vec4(handleColor),
        circleSegments
    )

    dl:AddText(
        imgui.ImVec2(p.x + size.x + r, p.y + r - (r / 2) - (imgui.CalcTextSize(label).y / 4)),
        imgui.GetColorU32Vec4(imgui.GetStyle().Colors[imgui.Col.Text]),
        label
    )

    return anim
end

local function BOTAOO(label, tabIndex, yPosition)
    local isActive = (activeTab == tabIndex)
    imgui.SetCursorPos(imgui.ImVec2((15) * DPI, yPosition * DPI))

    if isActive then
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.25, 0.55, 0.75, 1.0))
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.3, 0.6, 0.85, 1.0))
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.35, 0.65, 0.95, 1.0))
        imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.72, 0.85, 1.00, 1.0))
    else
        imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0.0, 0.0, 0.0, 0.0))
        imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0.1, 0.1, 0.1, 0.2))
        imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0.2, 0.2, 0.2, 0.3))
        imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.64, 0.75, 0.85, 1.0))
    end

    if imgui.Button(label, imgui.ImVec2(130 * DPI, 36 * DPI)) then
        activeTab = tabIndex
    end

    imgui.PopStyleColor(4)
end

imgui.OnInitialize(function()
    local config = imgui.ImFontConfig()
    config.MergeMode = true
    config.PixelSnapH = true
    imgui.GetIO().MouseDrawCursor = true
    imgui.GetStyle().MouseCursorScale = 0.9 * DPI
    local iconRanges = imgui.new.ImWchar[3](faicons.min_range, faicons.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(
        faicons.get_font_data_base85("solid"),
        14 * DPI,
        config,
        iconRanges
    )
end)

imgui.OnFrame(function() return qdl[0] end, function()
   imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(0.0, 0.0, 0.0, 1.0))
    imgui.SetNextWindowPos(imgui.ImVec2(600, 350), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(700 * DPI, 395 * DPI), imgui.Cond.Always)
    imgui.Begin("quadrilhalideranca", qdl, flags)

local offset = 160 * DPI
local draw_list = imgui.GetWindowDrawList()
local p = imgui.GetWindowPos()

local topY = p.y + 20 * DPI
local bottomY = (p.y + imgui.GetWindowHeight()) - 20 * DPI

 draw_list:AddLine(
    imgui.ImVec2(p.x + offset, topY),
    imgui.ImVec2(p.x + offset, bottomY),
    imgui.GetColorU32Vec4(imgui.ImVec4(0.2, 0.2, 0.2, 1.0)),
    1.0
)
    
CustomTab("\xef\x81\x9b", "Aim", 1, 30, activeTab == 1)
CustomTab("\xef\x81\xae", "Silent Aim", 2, 60, activeTab == 2)
CustomTab("\xef\x81\xae", "Wall Hack", 3, 90, activeTab == 3)

    imgui.SetCursorPos(imgui.ImVec2(5 * DPI, 5 * DPI))
    imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.72, 0.85, 1.00, 1.0))
    imgui.Text("Low", EspSulista.show_skeleton)
    
if activeTab == 1 then 
    
    imgui.SetCursorPos(imgui.ImVec2(235 * DPI, 37 * DPI))
    imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.72, 0.85, 1.00, 1.0))
    imgui.Text("Smooth-Aim", enable)
    imgui.SetCursorPos(imgui.ImVec2(175 * DPI, 37 * DPI))
    imgui.ToggleButton(" ", imgui.ImVec2(36 * DPI, 18 * DPI), enable)
 
    imgui.SetCursorPos(imgui.ImVec2(417 * DPI, 75 * DPI))
    imgui.Text("Fov")
    imgui.PushItemWidth(190 * DPI)
    imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(imgui.Col.FrameBgActive, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(imgui.Col.SliderGrab, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(imgui.Col.SliderGrabActive, imgui.ImVec4(0, 0, 0, 0))
    imgui.SetCursorPos(imgui.ImVec2(175 * DPI, 65 * DPI))
    imgui.SliderFloat("##quwuqysts", fovSizeAIM, 1.0, 450.0, "")
    imgui.PopStyleColor(4)
    imgui.PopItemWidth()
    imgui.SetCursorPos(imgui.ImVec2(175 * DPI, 65 * DPI))
    customSliderFloat("fov", fovSizeAIM, 1.0, 450.0, "%.0f")
        
    imgui.SetCursorPos(imgui.ImVec2(417 * DPI, 113 * DPI))
    imgui.Text("distanceAIM")
    imgui.PushItemWidth(190 * DPI)
    imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(imgui.Col.FrameBgActive, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(imgui.Col.SliderGrab, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(imgui.Col.SliderGrabActive, imgui.ImVec4(0, 0, 0, 0))
    imgui.SetCursorPos(imgui.ImVec2(175 * DPI, 103 * DPI))
    imgui.SliderFloat("##kaoqppoo", distanceAIM, 1.0, 450.0, "")
    imgui.PopStyleColor(4)
    imgui.PopItemWidth()
    imgui.SetCursorPos(imgui.ImVec2(175 * DPI, 103 * DPI))
    customSliderFloat("distanceAIM", distanceAIM, 1.0, 450.0, "%.0f")
            
    imgui.SetCursorPos(imgui.ImVec2(417 * DPI, 151 * DPI))
    imgui.Text("Smooth")
    imgui.PushItemWidth(190 * DPI)
    imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(imgui.Col.FrameBgActive, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(imgui.Col.SliderGrab, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(imgui.Col.SliderGrabActive, imgui.ImVec4(0, 0, 0, 0))
    imgui.SetCursorPos(imgui.ImVec2(175 * DPI, 141 * DPI))
    imgui.SliderFloat("##tsfqvcccs", smoothvalue, 1.0, 100.0, "")
    imgui.PopStyleColor(4)
    imgui.PopItemWidth()
    imgui.SetCursorPos(imgui.ImVec2(175 * DPI, 141 * DPI))
    customSliderFloat("smooth", smoothvalue, 1.0, 100.0, "%.0f")    
       
local function desativarTodosExceto(opcao)
    aimbotpjl.cabecaAIM[0]       = (opcao == "cabeca")
    aimbotpjl.peitoaimboott[0]   = (opcao == "peito")
    aimbotpjl.virilhaaimboott[0] = (opcao == "perna")
end

imgui.SetCursorPos(imgui.ImVec2(200 * DPI, 189 * DPI))
imgui.Text("Cabeca")

imgui.SetCursorPos(imgui.ImVec2(200 * DPI, 223 * DPI))
imgui.Text("Peito")

imgui.SetCursorPos(imgui.ImVec2(200 * DPI, 257 * DPI))
imgui.Text("Perna")

imgui.SetCursorPos(imgui.ImVec2(175 * DPI, 185 * DPI))
if imgui.CustomCheckbox(" ", aimbotpjl.cabecaAIM) then
    desativarTodosExceto("cabeca")
    addOneOffSound(0, 0, 0, 1085)
end

imgui.SetCursorPos(imgui.ImVec2(175 * DPI, 219 * DPI))
if imgui.CustomCheckbox("  ", aimbotpjl.peitoaimboott) then
    desativarTodosExceto("peito")
    addOneOffSound(0, 0, 0, 1085)
end

imgui.SetCursorPos(imgui.ImVec2(175 * DPI, 253 * DPI))
if imgui.CustomCheckbox("   ", aimbotpjl.virilhaaimboott) then
    desativarTodosExceto("perna")
    addOneOffSound(0, 0, 0, 1085)
end
          
          elseif activeTab == 2 then 
          
    imgui.SetCursorPos(imgui.ImVec2(235 * DPI, 37 * DPI))
    imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.72, 0.85, 1.00, 1.0))
    imgui.Text("Silent-Aim", enableSilent)
    imgui.SetCursorPos(imgui.ImVec2(175 * DPI, 37 * DPI))
    imgui.ToggleButton(" ", imgui.ImVec2(36 * DPI, 18 * DPI), enableSilent)
 
    imgui.SetCursorPos(imgui.ImVec2(417 * DPI, 70 * DPI))
    imgui.Text("Fov")
    imgui.PushItemWidth(190 * DPI)
    imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(imgui.Col.FrameBgActive, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(imgui.Col.SliderGrab, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(imgui.Col.SliderGrabActive, imgui.ImVec4(0, 0, 0, 0))
    imgui.SetCursorPos(imgui.ImVec2(175 * DPI, 60 * DPI))
    imgui.SliderFloat("##pqopp", tamanhoFOVsilent, 1.0, 450.0, "")
    imgui.PopStyleColor(4)
    imgui.PopItemWidth()
    imgui.SetCursorPos(imgui.ImVec2(175 * DPI, 60 * DPI))
    customSliderFloat("size", tamanhoFOVsilent, 1.0, 450.0, "%.0f")
  
     imgui.SetCursorPos(imgui.ImVec2(235 * DPI, 96 * DPI))
    imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.72, 0.85, 1.00, 1.0))
    imgui.Text("WallShot", sanguesilent)
    imgui.SetCursorPos(imgui.ImVec2(175 * DPI, 97 * DPI))
    imgui.ToggleButton("  ", imgui.ImVec2(36 * DPI, 18 * DPI), sanguesilent)
    
     imgui.SetCursorPos(imgui.ImVec2(417 * DPI, 129 * DPI))
    imgui.Text("Distância Maxima")
    imgui.PushItemWidth(190 * DPI)
    imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(imgui.Col.FrameBgActive, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(imgui.Col.SliderGrab, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(imgui.Col.SliderGrabActive, imgui.ImVec4(0, 0, 0, 0))
    imgui.SetCursorPos(imgui.ImVec2(175 * DPI, 119 * DPI))
    imgui.SliderFloat("##kaoqppoo", distanceAIMSILENT, 1.0, 450.0, "")
    imgui.PopStyleColor(4)
    imgui.PopItemWidth()
    imgui.SetCursorPos(imgui.ImVec2(175 * DPI, 119 * DPI))
    customSliderFloat("aaaaapze", distanceAIMSILENT, 1.0, 450.0, "%.0f")
    
    elseif activeTab == 3 then 
    
    imgui.SetCursorPos(imgui.ImVec2(235 * DPI, 37 * DPI))
    imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.72, 0.85, 1.00, 1.0))
    imgui.Text("Chams", EspSulista.show_skeleton)
    imgui.SetCursorPos(imgui.ImVec2(175 * DPI, 37 * DPI))
    imgui.ToggleButton(" ", imgui.ImVec2(36 * DPI, 18 * DPI), EspSulista.show_skeleton)
    
    imgui.SetCursorPos(imgui.ImVec2(235 * DPI, 65 * DPI))
    imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(0.72, 0.85, 1.00, 1.0))
    imgui.Text("Linhas", EspSulista.show_line_and_distance)
    imgui.SetCursorPos(imgui.ImVec2(175 * DPI, 65 * DPI))
    imgui.ToggleButton("   ", imgui.ImVec2(36 * DPI, 18 * DPI), EspSulista.show_line_and_distance)
    end
    
imgui.End()
imgui.PopStyleColor()
end

)
function main()
    while true do
        wait(0)
        
        if isWidgetSwipedLeft(0xA1) then
                qdl[0] = not qdl[0]
            end
            
        lua_thread.create(Aimbot)
        drawESP()
        
        if isSampAvailable() then
            sampRegisterChatCommand("chatt", function()
                qdl[0] = not qdl[0]
            end)
        end
    end
 end
 
function colorToHex(r, g, b, a)
    return bit.bor(
        bit.lshift(math.floor(a * 255), 24),
        bit.lshift(math.floor(r * 255), 16),
        bit.lshift(math.floor(g * 255), 8),
        math.floor(b * 255)
    )
end

function getBonePosition(ped, bone)
    local pedptr = ffi.cast("void*", getCharPointer(ped))
    local posn = ffi.new("RwV3d[1]")
    gta._ZN4CPed15GetBonePositionER5RwV3djb(pedptr, posn, bone, false)
    return posn[0].x, posn[0].y, posn[0].z
end

local aimbotActive = false
local lastShootTime = 0
local cooldownTime = 0
local currentTime = 0
local enemySkinDisabled = true

function getCharSkinId(char)
    return getCharModel(char)
end

function Aimbot()
    if not enable[0] then return end

    currentTime = os.clock() * 1000

    if isWidgetPressedEx(WIDGET_ATTACK, 0) then
        if not aimbotActive then
            aimbotActive = true
            lastShootTime = currentTime
        end
    elseif aimbotActive and (currentTime - lastShootTime) > cooldownTime then
        aimbotActive = false
    end

    function getCameraRotation()
        return camera.aCams[0].fHorizontalAngle, camera.aCams[0].fVerticalAngle
    end

    function setCameraRotation(x, y)
        camera.aCams[0].fHorizontalAngle = x
        camera.aCams[0].fVerticalAngle = y
    end

    function convertCartesianCoordinatesToSpherical(pos)
        local diff = pos - vector3d(getActiveCameraCoordinates())
        local len = diff:length()
        if len == 0 then return 0, 0 end
        local angleX = math.atan2(diff.y, diff.x)
        local angleY = math.acos(diff.z / len)
        if angleX > 0 then angleX = angleX - math.pi else angleX = angleX + math.pi end
        return angleX, math.pi / 2 - angleY
    end

    function getCrosshairPositionOnScreen()
        local w, h = getScreenResolution()
        return w * posiX[0], h * posiY[0]
    end

    function getCrosshairRotation(depth)
        depth = depth or 5
        local x, y = getCrosshairPositionOnScreen()
        local worldCoords = vector3d(convertScreenCoordsToWorld3D(x, y, depth))
        return convertCartesianCoordinatesToSpherical(worldCoords)
    end

    function NormalizeAngle(angle)
        while angle > math.pi do angle = angle - 2 * math.pi end
        while angle < -math.pi do angle = angle + 2 * math.pi end
        return angle
    end

    function aimAtPointWithSniperScope(pos)
        local sx, sy = convertCartesianCoordinatesToSpherical(pos)
        setCameraRotation(sx, sy)
    end

    function aimAtPointWithM16(pos)
        if not aimbotActive then return end
        local sx, sy = convertCartesianCoordinatesToSpherical(pos)
        local tx, ty = getCrosshairRotation()
        local cx, cy = getCameraRotation()
        local divisor = math.max(smoothvalue[0], 0.01)
        local diffYaw = NormalizeAngle(sx - tx)
        local diffPitch = sy - ty
        local smoothYaw = cx + diffYaw / divisor
        local smoothPitch = cy + diffPitch / divisor
        setCameraRotation(smoothYaw, smoothPitch)
    end

    function safeGetBone(char, id)
        local x, y, z = getBonePosition(char, id)
        if x and y and z then return vector3d(x, y, z) end
    end

    function getNearCharToCenter(radius)
        local nearby = {}
        local w, h = getScreenResolution()
        for _, char in ipairs(getAllChars()) do
            if isCharOnScreen(char) and char ~= PLAYER_PED and not isCharDead(char) then
                local x, y, z = getCharCoordinates(char)
                local sx, sy = convert3DCoordsToScreen(x, y, z)
                local dist = getDistanceBetweenCoords2d(
                    w / 1.923 + posiX[0], h / 2.210 + posiY[0],
                    sx, sy
                )
                if isCurrentCharWeapon(PLAYER_PED, 34) then
                    dist = getDistanceBetweenCoords2d(w / 2, h / 2, sx, sy)
                end
                if dist <= tonumber(radius or h) then
                    table.insert(nearby, {dist, char})
                end
            end
        end
        table.sort(nearby, function(a, b) return a[1] < b[1] end)
        return #nearby > 0 and nearby[1][2] or nil
    end

    local nearChar = getNearCharToCenter(fovSizeAIM[0])
    if not nearChar then return end

    if VERIFICAskin[0] and getCharSkinId(PLAYER_PED) == getCharSkinId(nearChar) then
        enemySkinDisabled = true
        return
    end
    enemySkinDisabled = false

    local pX, pY, pZ = getCharCoordinates(PLAYER_PED)
    local targetBone = nil

    local boneOrder = {  
    {aimbotpjl.cabecaAIM[0], 5},
    {aimbotpjl.peitoaimboott[0], 3},  
    {aimbotpjl.virilhaaimboott[0], 1}
   } 

    for _, v in ipairs(boneOrder) do
        if v[1] then
            targetBone = safeGetBone(nearChar, v[2])
            if targetBone then break end
        end
    end

    if not targetBone then return end

    local distToBone = getDistanceBetweenCoords3d(pX, pY, pZ, targetBone.x, targetBone.y, targetBone.z)
    if distToBone > distanceAIM[0] then return end

    if not matarbackwallsAIM[0] then
        local hit, _, _, _, entityHit = processLineOfSight(
            pX, pY, pZ, targetBone.x, targetBone.y, targetBone.z,
            true, true, false, true,
            false, false, false, false
        )
        if hit and entityHit ~= nearChar then return end
    end

    local nMode = camera.aCams[0].nMode
    if nMode == 7 then
        aimAtPointWithSniperScope(targetBone)
    elseif nMode == 53 then
        aimAtPointWithM16(targetBone)
    elseif stickcamerawithoutmode[0] then
        local sx, sy = convertCartesianCoordinatesToSpherical(targetBone)
        local tx, ty = getCrosshairRotation()
        local cx, cy = getCameraRotation()
        local divisor = math.max(SmoothTap[0], 0.01)
        local diffYaw = NormalizeAngle(sx - tx)
        local diffPitch = sy - ty
        local smoothYaw = cx + diffYaw / divisor
        local smoothPitch = cy + diffPitch / divisor
        setCameraRotation(smoothYaw, smoothPitch)
    end
end

imgui.OnFrame(
    function()
        return circuloFOVAIM[0] and not isGamePaused()
    end,
function()
    local screenWidth, screenHeight = getScreenResolution()        
    local circleX = screenWidth / 1.923 + posiX[0]        
    local circleY = screenHeight / 2.210 + posiY[0]        
    local color = imgui.ImVec4(pjl.fovColorAim[0], pjl.fovColorAim[1], pjl.fovColorAim[2], pjl.fovColorAim[3])        
    local bordaaim = imgui.ImVec4(pjl.bordaaimon[0], pjl.bordaaimon[1], pjl.bordaaimon[2], pjl.bordaaimon[3])        
    local colorHex = imgui.ColorConvertFloat4ToU32(color)        

    if not isCurrentCharWeapon(PLAYER_PED, 34) then        
        imgui.GetBackgroundDrawList():AddCircleFilled(imgui.ImVec2(circleX, circleY), fovSizeAIM[0], colorHex, 300)        
        imgui.GetBackgroundDrawList():AddCircle(imgui.ImVec2(circleX, circleY), fovSizeAIM[0], imgui.ColorConvertFloat4ToU32(bordaaim), 300)        
    else        
        imgui.GetBackgroundDrawList():AddCircleFilled(imgui.ImVec2(screenWidth / 2, screenHeight / 2), fovSizeAIM[0], colorHex, 300)        
        imgui.GetBackgroundDrawList():AddCircle(imgui.ImVec2(screenWidth / 2, screenHeight / 2), fovSizeAIM[0], imgui.ColorConvertFloat4ToU32(bordaaim), 300)        
    end        
end)

imgui.OnFrame(
    function()
        return enableSilent[0] and not isGamePaused()
    end,
    function(circle)
        circle.HideCursor = true
        local screenWidth, screenHeight = getScreenResolution()
        local fovCenterX, fovCenterY
        local fovRadius = tamanhoFOVsilent[0]
        if isCurrentCharWeapon(PLAYER_PED, 34) then
            fovCenterX = screenWidth / 2
            fovCenterY = screenHeight / 2
        else
            fovCenterX = screenWidth * 1.923 * offsetsilentcirculoX[0]
            fovCenterY = screenHeight * 2.306 * offsetsilentcirculoY[0]
        end
        if circuloFOVsilent[0] then
            local segments = 300
            local circleColor = imgui.ImVec4(fovColor[0], fovColor[1], fovColor[2], fovColor[3])
            local bordaColor = imgui.ImVec4(bosrdabbsilen[0], bosrdabbsilen[1], bosrdabbsilen[2], bosrdabbsilen[3])
            imgui.GetBackgroundDrawList():AddCircle(
                imgui.ImVec2(fovCenterX, fovCenterY),
                fovRadius,
                imgui.ColorConvertFloat4ToU32(bordaColor),
                segments
            )
            imgui.GetBackgroundDrawList():AddCircleFilled(
                imgui.ImVec2(fovCenterX, fovCenterY),
                fovRadius,
                imgui.ColorConvertFloat4ToU32(circleColor),
                segments
            )
        end
        circuloFOV =
            cabecaSilent[0]
        if circuloFOV then
            local playersProcessed = 0
            local closestPlayerId = nil
            local closestDistance = math.huge
            local minDistance = distanceAIMSILENT[0]
            local alivePlayers = {}
            for playerId = 0, 999 do
                if maxPlayersInFOV ~= nil and playersProcessed >= maxPlayersInFOV then
                    break
                end
                local success, ped = sampGetCharHandleBySampPlayerId(playerId)
                if success and doesCharExist(ped) and isCharOnScreen(ped) and not isCharDead(ped) then
                    local pedX, pedY, pedZ = getCharCoordinates(ped)
                    local screenX, screenY = convert3DCoordsToScreen(pedX, pedY, pedZ)
                    if not matarbackwallsSilent[0] then
                        local playerX, playerY, playerZ = getCharCoordinates(PLAYER_PED)
                        local hit, _, _, _, entityHit =
                            processLineOfSight(
                            playerX,
                            playerY,
                            playerZ,
                            pedX,
                            pedY,
                            pedZ,
                            true,
                            true,
                            false,
                            true,
                            false,
                            false,
                            false,
                            false
                        )
                        if hit and entityHit ~= ped then
                            goto continue
                        end
                    end
                    if isPlayerInFOV(screenX, screenY, fovCenterX, fovCenterY, fovRadius) then
                        local distance = math.sqrt((screenX - fovCenterX) ^ 2 + (screenY - fovCenterY) ^ 2)
                        if distance <= minDistance then
                            table.insert(alivePlayers, {playerId = playerId, distance = distance})
                        end
                        playersProcessed = playersProcessed + 1
                    end
                end
                ::continue::
            end
            if #alivePlayers > 0 then
                table.sort(
                    alivePlayers,
                    function(a, b)
                        return a.distance < b.distance
                    end
                )
                closestPlayerId = alivePlayers[1].playerId
                local success, ped = sampGetCharHandleBySampPlayerId(closestPlayerId)
                if success then
                    local pedX, pedY, pedZ = getCharCoordinates(ped)
                    applyDamageToPlayer(closestPlayerId, pedX, pedY, pedZ, ped)
                end
            end
        end
    end
)
function isPlayerInFOV(playerScreenX, playerScreenY, fovCenterX, fovCenterY, radius)
    if not fovCenterX or not fovCenterY then
        return false
    end
    local dx = playerScreenX - fovCenterX
    local dy = playerScreenY - fovCenterY
    local distanceSquared = dx * dx + dy * dy
    return distanceSquared <= radius * radius
end
function verificarSkinAtiva(playerId)
    local mymodel = getCharModel(PLAYER_PED)
    local success, ped = sampGetCharHandleBySampPlayerId(playerId)
    if success and doesCharExist(ped) then
        local playerModel = getCharModel(ped)
        if verificarSKIN[0] and playerModel == mymodel then
            return false
        end
    end
    return true
end
function applyDamageToPlayer(Hitbox, pedX, pedY, pedZ, ped)
    if not pedX or not pedY or not pedZ or not ped then
        return
    end
    if enableSilent[0] and verificarSkinAtiva(Hitbox) and isCharShooting(PLAYER_PED) then
        local weaponId = getCurrentCharWeapon(PLAYER_PED)
        local weapon = getWeaponInfoById(weaponId)
        local hitboxes = {
            {cabecaSilent, 9},
           }
           
        if melmaiak[0] then
            local randomHitbox = math.random(1, #hitboxes)
            sampSendGiveDamage(Hitbox, weapon.dmg, weaponId, hitboxes[randomHitbox][2])
        else
            for _, hitbox in ipairs(hitboxes) do
                if hitbox[1][0] then
                    sampSendGiveDamage(Hitbox, weapon.dmg, weaponId, hitbox[2])
                end
            end
        end
        if sanguesilent[0] then
            local mx, my, mz = getCharCoordinates(PLAYER_PED)
            local dirX, dirY, dirZ = mx - pedX, my - pedY, mz - pedZ
            local length = math.sqrt(dirX ^ 2 + dirY ^ 2 + dirZ ^ 2)
            if length ~= 0 then
                dirX, dirY, dirZ = dirX / length, dirY / length, dirZ / length
            end
            addBlood(pedX + dirX, pedY + dirY, pedZ + 0.67, 0.2, 0.2, 0.2, 9920, ped)
        end
    end
end
local function isPlayerInFov(playerX, playerY)
    local deltaX = playerX - fovX[0]
    local deltaY = playerY - fovY[0]
    local distance = math.sqrt(deltaX * deltaX + deltaY * deltaY)
    if tamanhoFOVsilent[0] < minFov then
        return true
    end
    return distance <= tamanhoFOVsilent[0]
end
local function slientarivar()
    local targetX, targetY = getPlayerPos(targetId)
    if isPlayerInFov(targetX, targetY) then
        sendSilentBullet(targetId)
    end
end
local weapons = {
    {id = 22, delay = 160, dmg = 8.25, distance = 735, camMode = 53, weaponState = 2},
    {id = 23, delay = 120, dmg = 13.2, distance = 735, camMode = 53, weaponState = 2},
    {id = 24, delay = 800, dmg = 46.2, distance = 735, camMode = 53, weaponState = 2},
    {id = 25, delay = 800, dmg = 3.3, distance = 740, camMode = 53, weaponState = 1},
    {id = 26, delay = 120, dmg = 3.3, distance = 735, camMode = 53, weaponState = 2},
    {id = 27, delay = 120, dmg = 4.95, distance = 740, camMode = 53, weaponState = 2},
    {id = 28, delay = 50, dmg = 6.6, distance = 735, camMode = 53, weaponState = 2},
    {id = 29, delay = 90, dmg = 8.25, distance = 745, camMode = 53, weaponState = 2},
    {id = 30, delay = 90, dmg = 9.9, distance = 700, camMode = 53, weaponState = 2},
    {id = 31, delay = 90, dmg = 9.9, distance = 750, camMode = 53, weaponState = 2},
    {id = 32, delay = 70, dmg = 6.6, distance = 750, camMode = 53, weaponState = 2},
    {id = 33, delay = 800, dmg = 24.75, distance = 700, camMode = 53, weaponState = 1},
    {id = 34, delay = 900, dmg = 41.25, distance = 320, camMode = 7, weaponState = 1},
    {id = 38, delay = 20, dmg = 46.2, distance = 750, camMode = 53, weaponState = 2}
}
local weaponCooldowns = {}
function getWeaponInfoById(id)
    for _, weapon in pairs(weapons) do
        if weapon.id == id then
            return weapon
        end
    end
    return nil
end
function onPlayerAttack(player, weaponId)
    local weapon = getWeaponInfoById(weaponId)
    if weapon then
        local currentTime = getCurrentTime()
        if not weaponCooldowns[player] or (currentTime - weaponCooldowns[player]) >= weapon.delay then
            weaponCooldowns[player] = currentTime
            applyDamageToTarget(player, weapon.dmg)
            setCameraMode(player, weapon.camMode)
        end
    end
end
function getCurrentTime()
    return os.clock() * 0
end
function applyDamageToTarget(player, damage)
end
function setCameraMode(player, camMode)
end
function rand()
    return math.random(-50, 50) / 100
end
function getMyId()
    return select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
end
function sampev.onBulletSync(playerId, data)
    if data.targetId == getMyId() then
        shootingAtMe = playerId
    end
end
function sampev.onSendTakeDamage(playerId, damage, weapon, bodypart)
    shootingAtMe = playerId
end
function sampev.onSendGiveDamage(data)
    if hggostoso then
        return false
    end
end
function getBonePosition(ped, bone)
    local pedptr = ffi.cast("void*", getCharPointer(ped))
    local posn = ffi.new("RwV3d[1]")
    gta._ZN4CPed15GetBonePositionER5RwV3djb(pedptr, posn, bone, false)
    return posn[0].x, posn[0].y, posn[0].z
end

function renderDrawBoxWithBorder(x, y, w, h, color, thickness)

    renderDrawLine(x, y, x + w, y, thickness, color)

    renderDrawLine(x, y + h, x + w, y + h, thickness, color)

    renderDrawLine(x, y, x, y + h, thickness, color)

    renderDrawLine(x + w, y, x + w, y + h, thickness, color)
end

function drawESP() if not EspSulista.enabled[0] then return end

local bit = require("bit")
local function rgbaToHex(r, g, b, a)
    r = math.floor(r * 255)
    g = math.floor(g * 255)
    b = math.floor(b * 255)
    a = math.floor(a * 255)
    return bit.bor(bit.lshift(a, 24), bit.lshift(r, 16), bit.lshift(g, 8), b)
end

local white = rgbaToHex(1.0, 1.0, 1.0, 1.0)
local localX, localY, localZ = getCharCoordinates(PLAYER_PED)

for playerId = 0, sampGetMaxPlayerId() do
    if sampIsPlayerConnected(playerId) then
        local result, playerPed = sampGetCharHandleBySampPlayerId(playerId)

        if result and playerPed ~= PLAYER_PED and isCharOnScreen(playerPed) then
            local targetX, targetY, targetZ = getCharCoordinates(playerPed)
            local distance = getDistanceBetweenCoords3d(localX, localY, localZ, targetX, targetY, targetZ)

            if distance <= EspSulista.max_distance[0] then
                local screenX, screenY = convert3DCoordsToScreen(targetX, targetY, targetZ + 1.0)
                local nick = sampGetPlayerNickname(playerId)
                local health = sampGetPlayerHealth(playerId)
                local armor = sampGetPlayerArmor(playerId)

                if screenX and screenY then
                    if EspSulista.show_name[0] then
                        renderFontDrawText(EspSulista.font, nick, screenX -30, screenY -30, white)
                    end

                    if EspSulista.show_distance[0] then
                        renderFontDrawText(EspSulista.font, string.format("%.1fm", distance), screenX, screenY - 15, white)
                    end

                    if EspSulista.show_health_armor[0] then
                        local healthWidth = 50 * (health / 100)
                        renderDrawBox(screenX - 25, screenY -15, 50, 5, 0xFF000000)
                        renderDrawBox(screenX - 25, screenY -15, healthWidth, 5, white)

                        if armor > 0 then
                            local armorWidth = 50 * (armor / 100)
                            renderDrawBox(screenX - 25, screenY + 7, 50, 3, 0xFF000000)
                            renderDrawBox(screenX - 25, screenY + 7, armorWidth, 3, white)
                        end
                    end

                    if EspSulista.show_line_and_distance[0] then
                        local selfScreenX, selfScreenY = convert3DCoordsToScreen(localX, localY, localZ)
                        if selfScreenX and selfScreenY then
                            renderDrawLine(selfScreenX, selfScreenY, screenX, screenY, 1, white)
                        end
                    end

                    if EspSulista.show_skeleton[0] then
                        for _, bone in ipairs(bones) do
                            local x1, y1, z1 = getBonePosition(playerPed, bone)
                            local x2, y2, z2 = getBonePosition(playerPed, bone + 1)
                            local r1, sx1, sy1 = convert3DCoordsToScreenEx(x1, y1, z1)
                            local r2, sx2, sy2 = convert3DCoordsToScreenEx(x2, y2, z2)
                            if r1 and r2 then
                                renderDrawLine(sx1, sy1, sx2, sy2, 4, white)
                            end                                                     
                        end
                    end

                    if EspSulista.show_box[0] then
    local x1, y1 = convert3DCoordsToScreen(targetX, targetY, targetZ + 1.0)
    local x2, y2 = convert3DCoordsToScreen(targetX, targetY, targetZ - 1.0)

    if x1 and y1 and x2 and y2 then
        local height = y2 - y1
        local width = height / 2

        local topLeftX = x1 - width / 2
        local topLeftY = y1

        renderDrawBoxWithBorder(topLeftX, topLeftY, width, height, white, 1)
    end
end

                    if EspSulista.show_weapon[0] then
    local weaponId = getCurrentCharWeapon(playerPed)

    local weaponNames = {
        [0] = "Fist", [1] = "Brass Knuckles", [22] = "Pistol", [23] = "Silenced",
        [24] = "Deagle", [25] = "Shotgun", [26] = "Sawn-off", [27] = "Spas-12",
        [28] = "Uzi", [29] = "MP5", [30] = "AK-47", [31] = "M4",
        [32] = "Tec-9", [33] = "Rifle", [34] = "Sniper", [35] = "Rocket",
        [36] = "HS Rocket", [38] = "Minigun"
    }

    local weaponName = weaponNames[weaponId] or ("ID: " .. weaponId)
    renderFontDrawText(EspSulista.font, weaponName, screenX - 30, screenY + 15, white)
end

                  if EspSulista.show_status[0] then
    local status = "STATUS"
    local statusY = EspSulista.show_weapon[0] and (screenY + 30) or (screenY + 15)
    renderFontDrawText(EspSulista.font, status, screenX - 30, statusY, white)
end

                end
            end
        end
    end
end

end