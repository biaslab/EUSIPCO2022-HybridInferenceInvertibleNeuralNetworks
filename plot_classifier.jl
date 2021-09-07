using PGFPlotsX
using HDF5
using LaTeXStrings

begin
    data_x = h5read("exports/data/classified_data.h5", "x_init")
    data_y = h5read("exports/data/classified_data.h5", "y_init")
    data_y_pred = h5read("exports/data/classified_data.h5", "y_pred")
    data_x_map = h5read("exports/data/classified_data.h5", "x_map")
    data_y_map = h5read("exports/data/classified_data.h5", "y_map")
end

x = range(minimum(data_x_map[1,:]); stop=maximum(data_x_map[1,:]), length = Int(sqrt(length(data_x_map[1,:]))))
y = range(minimum(data_x_map[2,:]); stop=maximum(data_x_map[2,:]), length = Int(sqrt(length(data_x_map[2,:]))))

push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepgfplotslibrary{patchplots}")

plt_data = @pgf GroupPlot(
    # group plot options
    {
        group_style = {
            group_size = "3 by 1",
            horizontal_sep = "1.5cm",
        },
        width = "\\textwidth / 3"
    },

    # axis 1 (true labels)
    {
        xlabel=L"$\mu^{(1)}$",
        ylabel=L"$\mu^{(2)}$",
        grid = "major",
        style = {thick},
        title = "true labels"
    },
    # plots for axis 1
    Plot(
        {
            scatter,
            only_marks,
            scatter_src="explicit"
        }, 
        Table(
            {
                meta = "label"
            },
            x = data_x[:,1], 
            y = data_x[:,2], 
            label = data_y
        ),
    ),
    
    # axis 2 (predicted labels)
    {
        xlabel=L"$\mu^{(1)}$",
        ylabel=L"$\mu^{(2)}$",
        grid = "major",
        style = {thick},
        title = "predicted labels"
    },
    # plots for axis 2
    Plot(
        {
            scatter,
            only_marks,
            scatter_src="explicit"
        }, 
        Table(
            {
                meta = "label"
            },
            x = data_x[:,1], 
            y = data_x[:,2], 
            label = data_y_pred
        ),
    ),

    # axis 3 (filled contour)
    # {
    #     xlabel=L"$\mu^{(1)}$",    # TODO: add bold font in paper!
    #     ylabel=L"$\mu^{(2)}$",
    #     grid = "major",
    #     title = "classification map"
    # },
    # # plots for axis 3
    # Plot(
    #     {
    #         patch,
    #         patch_refines=3,
	# 	    shader="faceted interp",
	# 	    patch_type="biquadratic"
    #     },
    #     Table(
    #         x = data_x_map[1,:],
    #         y = data_x_map[2,:],
    #         z = data_y_map
    #     ),
    # ),

    {
        xlabel=L"$\mu^{(1)}$",    # TODO: add bold font in paper!
        ylabel=L"$\mu^{(2)}$",
        grid = "major",
        title = "classification map",
        view = (0, 90)
    },
    Plot3(
        {
            surf,
            shader = "interp",
        },
        Coordinates(x, y, reshape(data_y_map, (length(x), length(y))))
    )
)

pgfsave("exports/figures/classified_data.tikz", plt_data)