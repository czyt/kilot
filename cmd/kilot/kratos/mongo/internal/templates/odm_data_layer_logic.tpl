package {{.DataPkg}}

import (
	"context"
	"github.com/Kamva/mgm"
	"github.com/Kamva/mgm/operator"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"{{.BizPkg}}"
	"time"
)

type demoDataRepo struct {
	model mgm.Model
	// Todo: add your data and loggers here
	// data *Data
}

func ({{.ModelIdentifier}} {{.ModelNameLowCase}}DataRepo) CreateOne{{.ModelName}}(ctx context.Context, data *{{.BizPkg}}.{{.ModelName}}, opts ...*options.InsertOneOptions) (result *mongo.InsertOneResult, err error) {
	return mgm.Coll({{.ModelIdentifier}}.model).InsertOne(ctx, data, opts...)
}

func ({{.ModelIdentifier}} {{.ModelNameLowCase}}DataRepo) CreateMany{{.ModelName}}(ctx context.Context, data []interface{}, opts ...*options.InsertManyOptions) (result *mongo.InsertManyResult, err error) {
	return mgm.Coll({{.ModelIdentifier}}.model).InsertMany(ctx, data, opts...)
}

func ({{.ModelIdentifier}} {{.ModelNameLowCase}}DataRepo) FindOne{{.ModelName}}(ctx context.Context, filter interface{}, opts ...*options.FindOneOptions) (result *{{.BizPkg}}.{{.ModelName}}, err error) {
	result = &{{.BizPkg}}.{{.ModelName}}{}
	if err = mgm.Coll({{.ModelIdentifier}}.model).FindOne(ctx, filter, opts...).Decode(result); err != nil {
		return nil, err
	}
	return result, nil
}

func ({{.ModelIdentifier}} {{.ModelNameLowCase}}DataRepo) FindOne{{.ModelName}}ById(ctx context.Context, id string, opts ...*options.FindOneOptions) (result *{{.BizPkg}}.{{.ModelName}}, err error) {
	recordId, err := {{.ModelIdentifier}}.model.PrepareID(id)
	if err != nil {
		return nil, err
	}
	return {{.ModelIdentifier}}.FindOne{{.ModelName}}(ctx, bson.M{"_id": recordId}, opts...)
}

func ({{.ModelIdentifier}} {{.ModelNameLowCase}}DataRepo) Find{{.ModelName}}(ctx context.Context, filter interface{}, opts ...*options.FindOptions) (result []*{{.BizPkg}}.{{.ModelName}}, err error) {
	result = make([]*{{.BizPkg}}.{{.ModelName}}, 0)
	cursor, err := mgm.Coll({{.ModelIdentifier}}.model).Find(ctx, filter, opts...)
	if err != nil {
		return nil, err
	}
	if err := cursor.All(context.Background(), &result); err != nil {
		return nil, err
	}
	return result, nil
}

func ({{.ModelIdentifier}} {{.ModelNameLowCase}}DataRepo) Estimated{{.ModelName}}Count(ctx context.Context, opts ...*options.EstimatedDocumentCountOptions) (int64, error) {
	return mgm.Coll({{.ModelIdentifier}}.model).EstimatedDocumentCount(ctx, opts...)
}

func ({{.ModelIdentifier}} {{.ModelNameLowCase}}DataRepo) GetMatch{{.ModelName}}Count(ctx context.Context, filter interface{}, opts ...*options.CountOptions) (int64, error) {
	return mgm.Coll({{.ModelIdentifier}}.model).CountDocuments(ctx, filter, opts...)
}

func ({{.ModelIdentifier}} {{.ModelNameLowCase}}DataRepo) UpdateOne{{.ModelName}}(ctx context.Context, filter interface{}, data interface{}, opts ...*options.FindOneAndUpdateOptions) *mongo.SingleResult {
	return mgm.Coll({{.ModelIdentifier}}.model).FindOneAndUpdate(ctx, filter, data, opts...)
}

func ({{.ModelIdentifier}} {{.ModelNameLowCase}}DataRepo) UpdateOne{{.ModelName}}ById(ctx context.Context, id string, data interface{}, opts ...*options.FindOneAndUpdateOptions) *mongo.SingleResult {
	recordId, err := {{.ModelIdentifier}}.model.PrepareID(id)
	if err != nil {
		return nil
	}
	return mgm.Coll({{.ModelIdentifier}}.model).FindOneAndUpdate(ctx, bson.M{"_id": recordId}, data, opts...)

}

func ({{.ModelIdentifier}} {{.ModelNameLowCase}}DataRepo) Update{{.ModelName}}(ctx context.Context, filter interface{}, data interface{}, opts ...*options.UpdateOptions) (*mongo.UpdateResult, error) {
	return mgm.Coll({{.ModelIdentifier}}.model).UpdateMany(ctx, filter, data, opts...)
}

func ({{.ModelIdentifier}} {{.ModelNameLowCase}}DataRepo) DeleteOne{{.ModelName}}(ctx context.Context, filter interface{}, opts ...*options.FindOneAndDeleteOptions) *mongo.SingleResult {
	return mgm.Coll({{.ModelIdentifier}}.model).FindOneAndDelete(ctx, filter, opts...)
}

func ({{.ModelIdentifier}} {{.ModelNameLowCase}}DataRepo) DeleteOne{{.ModelName}}ById(ctx context.Context, id string, opts ...*options.FindOneAndDeleteOptions) *mongo.SingleResult {
	recordId, err := {{.ModelIdentifier}}.model.PrepareID(id)
	if err != nil {
		return nil
	}
	return mgm.Coll({{.ModelIdentifier}}.model).FindOneAndDelete(ctx, bson.M{"_id": recordId}, opts...)
}

func ({{.ModelIdentifier}} {{.ModelNameLowCase}}DataRepo) Delete{{.ModelName}}(ctx context.Context, filter interface{}, opts ...*options.DeleteOptions) (*mongo.DeleteResult, error) {
	return mgm.Coll({{.ModelIdentifier}}.model).DeleteMany(ctx, filter, opts...)
}

{{if .SoftDeleteFeature}}
func ({{.ModelIdentifier}} {{.ModelNameLowCase}}DataRepo) SoftDeleteOne{{.ModelName}}(ctx context.Context, filter interface{}, opts ...*options.FindOneAndUpdateOptions) *mongo.SingleResult {
	updateData := bson.M{operator.Set: bson.M{"is_deleted": true,
		"deleted_at": primitive.NewDateTimeFromTime(time.Now()),
	}}
	return mgm.Coll({{.ModelIdentifier}}.model).FindOneAndUpdate(ctx, filter, updateData, opts...)
}

func ({{.ModelIdentifier}} {{.ModelNameLowCase}}DataRepo) SoftDeleteOne{{.ModelName}}ById(ctx context.Context, id string, opts ...*options.FindOneAndUpdateOptions) *mongo.SingleResult {
	recordId, err := {{.ModelIdentifier}}.model.PrepareID(id)
	if err != nil {
		return nil
	}
	return {{.ModelIdentifier}}.SoftDeleteOne{{.ModelName}}(ctx, bson.M{"_id": recordId}, opts...)
}

func ({{.ModelIdentifier}} {{.ModelNameLowCase}}DataRepo) SoftDelete{{.ModelName}}(ctx context.Context, filter interface{}, opts ...*options.UpdateOptions) (*mongo.UpdateResult, error) {
	updateData := bson.M{operator.Set: bson.M{"is_deleted": true,
		"deleted_at": primitive.NewDateTimeFromTime(time.Now()),
	}}
	return mgm.Coll({{.ModelIdentifier}}.model).UpdateMany(ctx, filter, updateData, opts...)
}
{{end}}
func New{{.ModelName}}DataRepo() {{.BizPkg}}.{{.ModelName}}Provider {
	return &demoDataRepo{
		model: &{{.BizPkg}}.{{.ModelName}}{},
	}
}