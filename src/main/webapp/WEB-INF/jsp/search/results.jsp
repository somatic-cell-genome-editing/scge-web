
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/fontawesome.min.css" />
<h1>${selectedFilters.editors.type}</h1>
<script>
        $(function () {


            selectedEditorType= "${selectedFilters.editorType}";
            selectedEditorSubType ="${selectedFilters.editorSubType}";
            selectedEditorSpecies ="${selectedFilters.editorSpecies}";
            selectedDsType="${selectedFilters.deliveryType}";
            selectedDeliverySubtype="${selectedFilters.deliverySubtype}";

            selectedModelType="${selectedFilters.modelType}";
            selectedModelSubType="${selectedFilters.modelSubtype}";
            selectedModelOrganism="${selectedFilters.modelOrganism}";
            selectedReporter="${selectedFilters.transgeneReporter}";
            selectedSpeciesType="${selectedFilters.species}";
            selectedWithExperiments="${selectedFilters.withExperiments}";
            selectedTargetTissue="${selectedFilters.tissueTerm}";
            selectedVector ="${selectedFilters.reporter}";
            selectedVectorType ="${selectedFilters.vectorType}";
            selectedVectorSubType ="${selectedFilters.vectorSubtype}";

            selectedGuideTargetLocus="${selectedFilters.guideTargetLocus}";
            selectedGuideCompatibility="${selectedFilters.guideCompatibility}";
            selectedGuideSpecies="${selectedFilters.guideSpecies}";

            selectedPi="${selectedFilters.pi}";
            selectedAccess="${selectedFilters.access}";
            selectedStatus="${selectedFilters.status}";
            selectedStudyType="${selectedFilters.studyType}";
            selectedInitiative="${selectedFilters.initiative}";

            selectedExperimentType= "${selectedFilters.experimentType}";
            selectedExperimentName= "${selectedFilters.experimentName}";
        })

    </script>
    <script src="/toolkit/js/search/facet.js"></script>
    <style>

          h4{
              color:#2a6496;
          /*    font-weight: bold;*/
          }
         .search-results-anchor {
                color:#004fba;
                text-decoration: underline;
            }
        .fa-cog {
            color: lightgrey;
        }
        .facet-head{
            font-weight: bold;
        }
        em{
            background-color: yellow;
        }

    </style>

<div class="container-fluid">
    <div class="row" id="reloadResults">
        <%@include file="resultsPage.jsp"%>
    </div>
</div>




