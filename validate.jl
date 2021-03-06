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