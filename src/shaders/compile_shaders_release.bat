@echo off

if not exist .\..\..\build\Release\spirv (
    mkdir .\..\..\build\Release\spirv
)

set dxc_dir=.\..\..\third_party\dxc
set dxc=%dxc_dir%\dxc.exe

set spirv_dir=.\..\..\build\Release\spirv

for %%f in (*.hlsl) do (
    %dxc% -spirv -T vs_6_0 -E main_vs -Fo %spirv_dir%\%%~nf.vb %%f
    %dxc% -spirv -T ps_6_0 -E main_fs -Fo %spirv_dir%\%%~nf.fb %%f
)
