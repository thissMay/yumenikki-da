using Godot;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq.Expressions;
using System.Threading.Tasks.Dataflow;

[GlobalClass]
[Tool]

public partial class ShaderCombination : Resource
{
    const string STR_FUNC_VERTEX    = "vertex()";
    const string STR_FUNC_FRAGMENT  = "fragment()";
 
    const string CHECK_RENDERMODE = "render_mode";
    const string CHECK_SHADERTYPE = "shader_type";
    const string CHECK_INCLUDE    = "#include";

    const string RM_DISABLED    = "disabled";
    const string RM_UNSHADED    = "unshaded";
    const string RM_BLEND_ADD   = "blend_add";
    const string RM_BLEND_SUB   = "blend_sub";
    const string RM_BLEND_MUL   = "blend_mul";
    const string RM_BLEND_MIX   = "blend_mix";
    const string RM_BLEND_VERTEX_WORLD_COORDS   = "world_vertex_coords;";

    [ExportToolButton("Combine.")] Callable combine => Callable.From(() => Combine());
    
    [ExportGroup("Shaders and Combined Shader.")]
    [Export] Godot.Collections.Array<Shader> shaders = new();
    [Export] ShaderMaterial combinedShader = new();
    [ExportGroup("Combined Shader Properties.")]
    [Export] RENDER_MODE renderMode;
    [Export] SHADER_TYPE shaderType;
    [ExportGroup("Combined Shader Properties./Additional Includes")]
    [Export] Godot.Collections.Array<Shader> includes = new();

    // enums
    [Flags]
    enum RENDER_MODE {
        disabled            = 0, 
        unshaded            = 1, 
        blend_add           = 2, 
        blend_sub           = 4,
        blend_mul           = 8,
        blend_mix           = 16,
        blend_premul        = 32, 
        world_vertex_coords = 64
    }

    enum SHADER_TYPE {
        canvasitem, 
        spatial, 
        particle, 
        sky
    }

    // strings to contain.
    HashSet<string> strIncludes;
    HashSet<string> vertexBodies;
    HashSet<string> fragmentBodies;
    HashSet<string> variables;

    string strBlock;

    public void Combine()
    {
        strBlock = "";
        
        if (shaders.Count <= 0) return;
        strIncludes     = new();
        vertexBodies    = new(); 
        fragmentBodies  = new(); 
        fragmentBodies  = new(); 
        variables       = new(); 

        try
        {
            foreach (Shader sh in shaders)
            {
                if (sh == null) continue;

                Godot.FileAccess reader = Godot.FileAccess.Open(sh.ResourcePath, Godot.FileAccess.ModeFlags.Read);
                ReadShader(sh, reader);
                reader.Close();
            }

            combinedShader.Shader = WriteShader();
        }

        catch (Exception e)
        {
            GD.Print(e.Source, e.Message);
        }
    }    

    void ReadShader(Shader shaderFile, in Godot.FileAccess reader)
    {
        if (shaderFile == null) return;

        while (reader.GetPosition() < reader.GetLength())
            AssessLine(reader.GetLine(), reader);
    }

    string ReadBlock(String line, in Godot.FileAccess reader)
    {
        Stack<char> c = new();

        string block = "";
        string l = line;

        do
        {
            l = reader.GetLine();

            if          (l.Contains('{'))
            {
                c.Push('{');
                block += l.Replace('{', ' ');
            }
            else if     (l.Contains('}'))
            {
                c.Pop(); 
                block += l.Replace('}', ' ');
            }
            else if     (l.Trim().Length > 0) 
            {
                block += l + "\n";
            }

        } while (c.Count > 0);

        return block;
    }

    Shader WriteShader()
    {
        Shader product = new();
        string strShaderType;
        string strRenderMode = "render_mode ";

        switch (shaderType)
        {
            case SHADER_TYPE.canvasitem:    strShaderType = "shader_type canvas_item;"; break;
            case SHADER_TYPE.particle:      strShaderType = "shader_type particle;";    break;
            case SHADER_TYPE.sky:           strShaderType = "shader_type sky;";         break;
            case SHADER_TYPE.spatial:       strShaderType = "shader_type spatial;";     break;
            default:                        strShaderType = "";     break;
        }

        if ((int)renderMode > 1)
        {
            Queue<string> rQueue = new();
            
            if ((int)renderMode % 2 == 0)  rQueue.Enqueue(RM_BLEND_ADD);
            if ((int)renderMode % 4 == 0)  rQueue.Enqueue(RM_BLEND_SUB);
            if ((int)renderMode % 8 == 0)  rQueue.Enqueue(RM_BLEND_MUL);
            if ((int)renderMode % 16 == 0) rQueue.Enqueue(RM_BLEND_MIX);
            if ((int)renderMode % 64 == 0) rQueue.Enqueue(RM_BLEND_VERTEX_WORLD_COORDS);

            if (rQueue.Count > 1)
                while(rQueue.Count > 0) strRenderMode += rQueue.Dequeue() + ", ";
            else
                strRenderMode += rQueue.Dequeue() + ";";
        }

        else if ((int)renderMode == 1) strRenderMode += RM_UNSHADED;
        else                      strRenderMode += RM_DISABLED;

        product.Code += strShaderType + "\n";
        product.Code += strRenderMode + "\n";

        product.Code += "\n"; 

        foreach (string i in strIncludes)
            product.Code += i + "\n";

        product.Code += strBlock;

        product.Code += "\n"; 

        product.Code += $"void {STR_FUNC_VERTEX}\n"; 
        product.Code += "{\n"; 
        foreach (string v in vertexBodies)
            product.Code += v + "\n";
        product.Code += "}\n"; 
        
        product.Code += "\n"; 

        product.Code += $"void {STR_FUNC_FRAGMENT}\n"; 
        product.Code += "{\n"; 
        foreach (string f in fragmentBodies)
            product.Code += f + "\n";
            
        product.Code += "}\n"; 

        return product;
    }

    public void AssessLine(string line, in Godot.FileAccess reader)
    {
        if (line.Length <= 0) return;

        // reading includes.
        if (line.Contains(CHECK_RENDERMODE, StringComparison.Ordinal) || line.Contains(CHECK_SHADERTYPE, StringComparison.Ordinal))
            return;
      
        if (line.Contains(CHECK_INCLUDE, StringComparison.Ordinal))
        {
            strIncludes.Add(line);
            return;
        }   

        if (line.Contains(STR_FUNC_VERTEX, StringComparison.Ordinal))
        {
            vertexBodies.Add(ReadBlock(line, reader));
            return;
        }
        
        else if (line.Contains(STR_FUNC_FRAGMENT, StringComparison.Ordinal))
        {
            fragmentBodies.Add(ReadBlock(line, reader));
            return;
        }

        else if (variables.Add(line))
        {
            strBlock += line + "\n";
        }
    }
}

