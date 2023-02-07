NAME      := elasticsearch
NAMESPACE := elasticsearch
CHART     := cnieg/elastic-stack 
CHART_VER := 1.1.4  
VALUES    := values.yaml

deploy:
	-kubectl create namespace $(NAMESPACE)
	helm upgrade -i -n $(NAMESPACE) $(NAME) $(CHART) --version $(CHART_VER) -f $(VALUES)


uninstall:
	helm uninstall -n $(NAMESPACE) $(NAME)

clean:
	-kubectl delete namespace $(NAMESPACE)

