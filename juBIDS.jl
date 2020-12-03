using JSON

function validate_root(
    root::String,
    validate::Bool=true
)
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

    subjects = String[]
    for name in readdir(root)
        println(name[1:3])
        if (name[1:3] == "sub") & isdir(joinpath(root, name))
            push!(subjects, name[5:end])
        end
    end

    return root, description, subjects
end 
