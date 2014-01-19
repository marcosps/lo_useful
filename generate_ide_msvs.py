import uuid
import os
import shutil

def solutionGetId():
    return uuid.uuid4()

def projectGetId():
    return uuid.uuid4()

def generateProjectFile(projectid, projectname):
    folderPath = '/home/Muxta/%s' % projectname
    if os.path.isdir(folderPath):
        try:
            os.remove(folderPath)
        except OSError:
            shutil.rmtree(folderPath)
    os.mkdir(folderPath)
    f = open('%s/%s.vcxproj' % (folderPath, projectname), 'w')
    f.write('<?xml version="1.0" encoding="utf-8"?>\r\n')
    f.write('<Project DefaultTargets="Build" ToolsVersion="4.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">\r\n')
    f.write('  <ItemGroup Label="ProjectConfigurations">\r\n')
    f.write('    <ProjectConfiguration Include="Debug|Win32">\r\n')
    f.write('      <Configuration>Debug</Configuration>\r\n')
    f.write('      <Platform>Win32</Platform>\r\n')
    f.write('    </ProjectConfiguration>\r\n')
    f.write('    <ProjectConfiguration Include="Release|Win32">\r\n')
    f.write('      <Configuration>Release</Configuration>\r\n')
    f.write('      <Platform>Win32</Platform>\r\n')
    f.write('    </ProjectConfiguration>\r\n')
    f.write('  </ItemGroup>\r\n')
    f.write('  <PropertyGroup Label="Globals">\r\n')
    f.write('    <ProjectGuid>{%s}</ProjectGuid>\r\n' % (projectid))
    f.write('    <RootNamespace>%s</RootNamespace>\r\n' % (projectname))
    f.write('  </PropertyGroup>\r\n')
    f.write('  <Import Project="$(VCTargetsPath)\Microsoft.Cpp.Default.props" />\r\n')
    f.write('  <PropertyGroup Condition="\'$(Configuration)|$(Platform)\'==\'Debug|Win32\'" Label="Configuration">\r\n')
    f.write('    <ConfigurationType>Application</ConfigurationType>\r\n')
    f.write('    <UseDebugLibraries>true</UseDebugLibraries>\r\n')
    f.write('    <PlatformToolset>v110</PlatformToolset>\r\n')
    f.write('    <CharacterSet>MultiByte</CharacterSet>\r\n')
    f.write('  </PropertyGroup>\r\n')
    f.write('  <PropertyGroup Condition="\'$(Configuration)|$(Platform)\'==\'Release|Win32\'" Label="Configuration">\r\n')
    f.write('    <ConfigurationType>Application</ConfigurationType>\r\n')
    f.write('    <UseDebugLibraries>false</UseDebugLibraries>\r\n')
    f.write('    <PlatformToolset>v110</PlatformToolset>\r\n')
    f.write('    <WholeProgramOptimization>true</WholeProgramOptimization>\r\n')
    f.write('    <CharacterSet>MultiByte</CharacterSet>\r\n')
    f.write('  </PropertyGroup>\r\n')
    f.write('  <Import Project="$(VCTargetsPath)\Microsoft.Cpp.props" />\r\n')
    f.write('  <ImportGroup Label="ExtensionSettings">\r\n')
    f.write('  </ImportGroup>\r\n')
    f.write('  <ImportGroup Label="PropertySheets" Condition="\'$(Configuration)|$(Platform)\'==\'Debug|Win32\'">\r\n')
    f.write('    <Import Project="$(UserRootDir)\Microsoft.Cpp.$(Platform).user.props" Condition="exists(\'$(UserRootDir)\Microsoft.Cpp.$(Platform).user.props\')" Label="LocalAppDataPlatform" />\r\n')
    f.write('  </ImportGroup>\r\n')
    f.write('  <ImportGroup Label="PropertySheets" Condition="\'$(Configuration)|$(Platform)\'==\'Release|Win32\'">\r\n')
    f.write('    <Import Project="$(UserRootDir)\Microsoft.Cpp.$(Platform).user.props" Condition="exists(\'$(UserRootDir)\Microsoft.Cpp.$(Platform).user.props\')" Label="LocalAppDataPlatform" />\r\n')
    f.write('  </ImportGroup>\r\n')
    f.write('  <PropertyGroup Label="UserMacros" />\r\n')
    f.write('  <PropertyGroup />\r\n')
    f.write('  <ItemDefinitionGroup Condition="\'$(Configuration)|$(Platform)\'==\'Debug|Win32\'">\r\n')
    f.write('    <ClCompile>\r\n')
    f.write('      <WarningLevel>Level3</WarningLevel>\r\n')
    f.write('      <Optimization>Disabled</Optimization>\r\n')
    f.write('    </ClCompile>\r\n')
    f.write('    <Link>\r\n')
    f.write('      <GenerateDebugInformation>true</GenerateDebugInformation>\r\n')
    f.write('    </Link>\r\n')
    f.write('  </ItemDefinitionGroup>\r\n')
    f.write('  <ItemDefinitionGroup Condition="\'$(Configuration)|$(Platform)\'==\'Release|Win32\'">\r\n')
    f.write('    <ClCompile>\r\n')
    f.write('      <WarningLevel>Level3</WarningLevel>\r\n')
    f.write('      <Optimization>MaxSpeed</Optimization>\r\n')
    f.write('      <FunctionLevelLinking>true</FunctionLevelLinking>\r\n')
    f.write('      <IntrinsicFunctions>true</IntrinsicFunctions>\r\n')
    f.write('    </ClCompile>\r\n')
    f.write('    <Link>\r\n')
    f.write('      <GenerateDebugInformation>true</GenerateDebugInformation>\r\n')
    f.write('      <EnableCOMDATFolding>true</EnableCOMDATFolding>\r\n')
    f.write('      <OptimizeReferences>true</OptimizeReferences>\r\n')
    f.write('    </Link>\r\n')
    f.write('  </ItemDefinitionGroup>\r\n')
    f.write('  <ItemGroup>\r\n')
    f.write('  </ItemGroup>\r\n')
    f.write('  <Import Project="$(VCTargetsPath)\Microsoft.Cpp.targets" />\r\n')
    f.write('  <ImportGroup Label="ExtensionTargets">\r\n')
    f.write('  </ImportGroup>\r\n')
    f.write('</Project>\r\n')
    f.close()

def generateProject(projectid, projectname):
    generateProjectFile(projectid, projectname)

def generateFiles():
    solutionUID = str(solutionGetId()).upper()    
    path = '../libo-core/'    
    projects = {}
    
    for name in os.listdir(path):
        
        if os.path.isdir(os.path.join(path, name)):
            
            if name == 'external' or name == 'workdir' or name == 'instdir' or name.startswith('.'):
                continue
            else:
                projects[name] = str(projectGetId()).upper()
        else:
            continue

    f = open('/home/Muxta/Teste.sln', 'w')
    
    f.write(inittemplate)
    
    for project in projects.keys():
        f.write('Project("{%s}") = "%s", "%s\\%s.vcxproj", "{%s}"\r\n' % (solutionUID, project, project, project, projects[project]))
        f.write('EndProject\r\n')
    
    f.write(globaltemplate)
    
    for project in projects.keys():
        f.write('        {%s}.Debug|Win32.ActiveCfg = Debug|Win32\r\n' % (projects[project]))
        f.write('        {%s}.Debug|Win32.Build.0 = Debug|Win32\r\n' % (projects[project]))
        f.write('        {%s}.Release|Win32.ActiveCfg = Release|Win32\r\n' % (projects[project]))
        f.write('        {%s}.Release|Win32.Build.0 = Release|Win32\r\n' % (projects[project]))
        
        generateProject(projects[project], project)
    
    f.write(endglobaltemplate)
    f.close()

inittemplate = """
Microsoft Visual Studio Solution File, Format Version 12.00
# Visual Studio Express 2012 for Windows Desktop
"""

globaltemplate = """Global
    GlobalSection(SolutionConfigurationPlatforms) = preSolution
        Debug|Win32 = Debug|Win32
        Release|Win32 = Release|Win32
    EndGlobalSection
    GlobalSection(ProjectConfigurationPlatforms) = postSolution
"""

endglobaltemplate = """    EndGlobalSection
    GlobalSection(SolutionProperties) = preSolution
        HideSolutionNode = FALSE
    EndGlobalSection
EndGlobal
"""

if __name__ == '__main__':
    generateFiles()