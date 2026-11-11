using Godot;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;

[GlobalClass]
[Tool]

public partial class ShaderCombination : Resource
{
    const string TEMPLATE_PATH = @"res://src/shaders/_empty_template.gdshader";

    const string FUNCTIONS_PLACEHOLDER      = "//%FUNCTIONS%";
    const string VERTEX_CALLS_PLACEHOLDER   = "//%VERTEX_CALLS%";
    const string FRAGMENT_CALLS_PLACEHOLDER = "//%FRAGMENT_CALLS%";

    const string VERTEX_FUNCTION_CHECK      = "vertex";
    const string FRAGMENT_FUNCTION_CHECK    = "fragment";

    [ExportToolButton("Combine.")] Callable combine => Callable.From(() => Combine());
    [Export] Godot.Collections.Array<Shader> shaders = new();

    [Export] Shader combinedShader;
    
    [Export] BLEND_MODE blendMode;
    [Export] SHADER_TYPE shaderType;

    // enums
    [Flags]
    enum BLEND_MODE {
        normal = 0, 
        blend_add = 1, 
        blend_disabled = 2, 
        blend_premul = 4, 
        blend_mul = 8}
    enum SHADER_TYPE {canvasitem, spatial, particle, sky}

    // strings to contain.
    HashSet<string> strIncludes;
    string strShaderType;

    public Shader Combine()
    {
        if (shaders.Count <= 0) return null;


        try
        {
            
            StreamReader reader = new(TEMPLATE_PATH);
            // Godot.FileAccess shaderReader = Godot.FileAccess.Open(TEMPLATE_PATH, Godot.FileAccess.ModeFlags.Read);
            Shader combined  = new();
            string combinedCode = "";


            foreach (Shader sh in shaders)
                ReadShader(sh, reader);

            combined.Code = combinedCode;

            GD.Print($"COMBINED CODE:: \n{combinedCode}");
            combinedShader = combined;
            return combined;
        }

        catch (Exception e)
        {
            GD.Print(e.Source, e.Message);
        }

        return null;
    }    

    void ReadShader(Shader shaderFile, in StreamReader reader)
    {
        while (!reader.EndOfStream)
          AssessLine(reader.ReadLine(), reader);
    }

    Shader WriteShader()
    {
        Shader product = new();

        string strBlendMode;
        string strShaderType;

        return null;
    }

    public void AssessLine(string line, in StreamReader reader)
    {
        // reading includes.
        if (line.Contains("#include", StringComparison.Ordinal))
        {
            strIncludes.Add(line);
            return;
        }   

        // reading methods
        if (line.StartsWith("void", StringComparison.Ordinal))
        {
            Stack<char> c = new();
            string l     = "";
            string block = "";

            c.Push('{');

            while (c.Count > 1)
            {
                l = reader.ReadLine();
                block += l;

                if (l.Contains('{')) c.Push('{');
                else if (l.Contains('}')) c.Pop();        
            }
        }
    }
}

