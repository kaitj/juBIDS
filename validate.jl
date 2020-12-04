using JSON

function validate_root(
    root::String,
    validate::Bool=true
)
    # Check if input root directory is string
    if typeof(root) != String
        error("root argument must be a string (or a type that ",
              "supports casting to string, such as ",
              "pathlib.Path) specifying the directory ",
              "containing the BIDS dataset.")
        exit
    end

    # Grab absolute path
    root = abspath(root)

    # Check if root directory exists
    if !isdir(root)
        error("BIDS root does not exist: $root")
    end 
    
    # Check and potentially validate dataset_description.json
    target = joinpath(root, "dataset_description.json")
    if !isfile(target)
        if validate == true
            error("'dataset_description.json' is missing from project root. ",
                  "Every valid BIDS dataset must have this file.")
        else
            description = nothing
        end
    else
        description = JSON.parsefile(target)
        if validate
            # ADD MANDATORY BIDS FIELDS
        end
    end

    return root, description
end 

struct BIDSFile
    path::String
end

struct BIDSNode
    path::String
#    root::BIDSNode
#    parent::BIDSNode
    children::Array{BIDSNode}
    files::Array{BIDSFile}
end

function gen_bids_tree(root_path)
    root, description = validate_root(root_path, false)
    root_node = BIDSNode(root_path, [], [])
    for (rootpath, dirs, files) in walkdir(root_path)
        for f in files
            bf = BIDSFile(f)
            push!(root_node.files, bf)
        end
        for d in dirs
            d = joinpath(rootpath, d)
            push!(root_node.children, gen_bids_tree(d))
        end
    break
    end
    return root_node
end
